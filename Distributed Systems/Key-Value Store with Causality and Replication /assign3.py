from flask import Flask, request, jsonify
import requests
import json
import os
import logging

app = Flask(__name__)
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("MyApp")
# Global Variables
kvstore = {}
vc = {}
causal_meta = {}
saddr = os.getenv('SOCKET_ADDRESS', '')
views = os.getenv('VIEW', '')
views_list = views.split(",") if views else []
test = []
# Initialize vector clocks for all servers
vc = {server: 0 for server in views_list}
replica_states = {server: 'online' for server in views_list}

# Helper Functions
# View README.md for a thorough 
def check_replica_health():
    for tests in test:
        logger.info(f"container: {tests}")
        try:
            response = requests.get(f'http://{tests}/health', timeout=5)
            if response.status_code == 200:
                logger.info(f"replica to be added: {tests}")
                test.remove(tests)
                add_replica_from_view(tests)
        except requests.RequestException:
            pass

    for replica in list(views_list):
        if replica != saddr:
            try:
                response = requests.get(f'http://{replica}/health', timeout=5)
                logger.info(f'response: {response.status_code}')
                if response.status_code != 200:
                    logger.info(f"replica to be removed: {replica}")
                    test.append(replica)
                    remove_replica_from_view(replica)
            except requests.RequestException:
                test.append(replica)
                remove_replica_from_view(replica)
def sync(replica):
    try:
        data = {
            "kvstore": kvstore,
            "vector_clock": vc
        }
        response = requests.put(f'http://{replica}/kvs/sync', json=data)

        if response.status_code == 200:
            logger.info(f"Data successfully synchronized with {replica}")
        else:
            logger.error(f"Failed to synchronize data with {replica}, status code: {response.status_code}")

    except requests.RequestException as e:
        logger.error(f"Error sending synchronization request to {replica}: {e}")

def add_replica_from_view(replica):
    if replica not in views_list:
        headers = {'deletion': 'True'}
        logger.info(f"Requesting addition of replica: {replica} from view")
        data = {"socket-address": replica}
        try:
            logger.info(f"saddr: {saddr} replica: {replica}")
            response = requests.put(f'http://{saddr}/view', json=data, headers=headers)
            if (response.status_code == 201):
                sync(replica)
        except requests.RequestException as e:
            pass
def remove_replica_from_view(replica):
    if replica in views_list:
        headers = {'deletion': 'True'}
        logger.info(f"Requesting removal of replica: {replica} from view")
        data = {"socket-address": replica}
        try:
            requests.delete(f'http://{saddr}/view', json=data, headers=headers)
        except requests.RequestException as e:
            logger.error(f"Error requesting removal of {replica}: {e}")

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({"status": "healthy"}), 200

def rule_one():
    vc[saddr] += 1

def rule_two(meta_clock):
    if meta_clock != None:
        for node, timestamp in meta_clock.items():
            if (saddr != node and timestamp != 0):
                vc[node] = max(vc.get(node, 0), timestamp)
                
def is_causal(meta_clock):
    if meta_clock is None:
        return True
    for node, timestamp in meta_clock.items():
            if(vc[node] < timestamp):
                return False
    return True

def broadcast_request(method, key, data):
    headers = {'broadcast': 'True'}

    forward = data.get_json()
    # Include the updated vector clock in the broadcast
    forward['causal-metadata'] = json.dumps(vc)

    for view in views_list:
        if view != saddr:
            url = f"http://{view}/kvs/{key}"
            try:
                if method == 'PUT':
                    requests.put(url, json=forward, headers=headers)
            except requests.RequestException as e:
                logger.error(f"Error sending request to {view}: {e}")


# View Operations
@app.route('/view', methods=['PUT', 'GET', 'DELETE'])
def manage_view():
    if 'deletion' not in request.headers:
        check_replica_health()
    if request.method == 'PUT':
        return add_view()
    elif request.method == 'GET':
        return get_view()
    elif request.method == 'DELETE':
        return remove_view()



def add_view():
    data = request.json
    new_instance = data.get("socket-address", "")
    if new_instance not in views_list:
        views_list.append(new_instance)
        logger.info(f"Added {new_instance} to view.")
        return jsonify({"result": "added"}), 201
    elif new_instance in views_list:
        return jsonify({"result": "already present"}), 200
    else:
        return jsonify({"error": "Invalid request"}), 400

def get_view():
    logger.info(f"Getting views: {views_list}")
    return jsonify({"view": views_list}), 200

def remove_view():
    data = request.json
    logger.info(f"data: {data}")
    delete_instance = data.get("socket-address", "")
    if delete_instance in views_list:
        views_list.remove(delete_instance)
        return jsonify({"result": "deleted"}), 200
    else:
        return jsonify({"error": "View has no such replica"}), 404
    
# Key-Value Operations

@app.route('/kvs/<key>', methods=['PUT', 'GET', 'DELETE'])
def manage_kvs(key):
    if request.method == 'PUT':
        return put_key(key)
    elif request.method == 'GET':
        return get_key(key)
    elif request.method == 'DELETE':
        return delete_key(key)
@app.route('/kvs/sync', methods=['PUT'])
def sync_handler():
    try:
        data = request.get_json()
        kvs = data.get('kvstore', {})
        vec = data.get('vector_clock', {})

        # Update kvstore and vector clock
        kvstore.update(kvs)
        for key, value in vec.items():
            vc[key] = max(vc.get(key, 0), value)

        return jsonify({"message": "Data synchronized successfully"}), 200

    except Exception as e:
        logger.error(f"Error during synchronization: {e}")
        return jsonify({"error": "Internal server error"}), 500

    

def put_key(key):
    try:
        data = request.get_json()
        value = data.get("value")
        causal_meta = data.get('causal-metadata')
        
        # Check if causal_meta is a string and parse it if necessary
        if isinstance(causal_meta, str):
            causal_meta = json.loads(causal_meta)
        
        # Update the vector clock based on the received causal metadata
        if 'broadcast' in request.headers:
            rule_two(causal_meta)
        rule_one()
        # Broadcast the update to other servers
        if 'broadcast' not in request.headers:
            broadcast_request('PUT', key, request)

        if not is_causal(causal_meta):
            logger.warning(f"Causal check failed. Received causal metadata: {causal_meta}, Local vector clock: {vc}")
            return jsonify({"error": "Causal dependencies not satisfied; try again later"}), 503

        if not value:
            return jsonify({"error": "PUT request does not specify a value"}), 400

        if len(key) > 50:
            return jsonify({"error": "Key is too long"}), 400

        created = key not in kvstore
        kvstore[key] = value
        
        logger.info(f"Before returning response. Causal metadata: {causal_meta}, Local vector clock: {vc}")
        return jsonify({"result": "created" if created else "replaced", "causal-metadata": json.dumps(vc)}), 201 if created else 200
    except Exception as e:
        print(f"An error occurred in put_key: {e}")
        return jsonify({"error": "Internal server error"}), 500

def get_key(key):
    if key in kvstore:
        data = request.get_json()
        causal_meta = data.get('causal-metadata')
        
        # Check if causal_meta is a string and parse it if necessary
        if isinstance(causal_meta, str):
            causal_meta = json.loads(causal_meta)

        if not is_causal(causal_meta):
            logger.warning(f"Causal check failed. Received causal metadata: {causal_meta}, Local vector clock: {vc}")
            return jsonify({"error": "Causal dependencies not satisfied; try again later"}), 503
        return jsonify({"result": "found", "value": kvstore[key], "causal-metadata": causal_meta}), 200
    else:
        return jsonify({"error": "Key does not exist"}), 404


def delete_key(key):
    data = request.get_json()
    causal_meta = data.get('causal-metadata')
    if isinstance(causal_meta, str):
        causal_meta = json.loads(causal_meta)
        
        # Update the vector clock based on the received causal metadata

    
    if key in kvstore:
        if 'broadcast' in request.headers:
            rule_two(causal_meta)
            
        rule_one()
        # Broadcast the update to other servers
        if 'broadcast' not in request.headers:
            broadcast_request('DELETE', key, request)
        del kvstore[key]
        return jsonify({"result": "deleted", "causal-metadata": json.dumps(vc)}), 200
    else:
        return jsonify({"error": "Key does not exist"}), 404

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.getenv('PORT', 8090)), debug=True)

    