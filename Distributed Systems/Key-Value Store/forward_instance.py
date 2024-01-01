from flask import Flask, request, jsonify
import requests
import os

app = Flask(__name__)

# Grabs Forwarding_Address environment variable
MAIN_INSTANCE_DNS = os.environ.get('FORWARDING_ADDRESS')

@app.route('/kvs/<key>', methods=['PUT', 'GET', 'DELETE'])
def forward_request(key):
    try:
        # Construct the URL for the main instance
        main_instance_url = f"http://{MAIN_INSTANCE_DNS}/kvs/{key}"
        
        # Forward headers
        headers = dict(request.headers)
        
        # Forward data based on the request method
        if request.method == 'PUT':
            data = request.get_json()
        else:
            data = None

        # Forward the request to the main instance
        response = requests.request(request.method, main_instance_url, headers=headers, json=data, timeout=10)
        
        # Return the response as received from the main instance
        return jsonify(response.json()), response.status_code

    except requests.ConnectionError:
        return jsonify({"error": "Cannot forward request"}), 503

    except Exception as e:
        return jsonify({"error": str(e)}), 503

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=8090)
