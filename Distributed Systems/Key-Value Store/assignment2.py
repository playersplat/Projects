from flask import Flask, request, jsonify

app = Flask(__name__)

# Initialize an empty dictionary to store key-value pairs
key_value_store = {}

# Request PUT
@app.route('/kvs/<key>', methods=['PUT'])
def put_key_value(key):
    try:
        data = request.get_json()
        if "value" in data:
            value = data["value"]
            if len(key) > 50:
                return jsonify({"error": "Key is too long"}), 400
            if key in key_value_store:
                key_value_store[key] = value
                return jsonify({"result": "replaced"}), 200
            else:
                key_value_store[key] = value
                return jsonify({"result": "created"}), 201
        else:
            return jsonify({"error": "PUT request does not specify a value"}), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 400

# Request GET
@app.route('/kvs/<key>', methods=['GET'])
def get_key_value(key):
    if key in key_value_store:
        return jsonify({"result": "found", "value": key_value_store[key]}), 200
    else:
        return jsonify({"error": "Key does not exist"}), 404

# Request DELETE
@app.route('/kvs/<key>', methods=['DELETE'])
def delete_key_value(key):
    if key in key_value_store:
        del key_value_store[key]
        return jsonify({"result": "deleted"}), 200
    else:
        return jsonify({"error": "Key does not exist"}), 404

if __name__ == '__main__':
    # Listen on all available network interfaces and on port 8090
    app.run(host='0.0.0.0', port=8090)
