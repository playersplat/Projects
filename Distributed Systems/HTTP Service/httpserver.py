import http.server
import json
from urllib.parse import parse_qs, urlparse

class My_Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/hello':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            res = {"message": "world"}
            res_json = json.dumps(res).encode('utf-8')
            self.wfile.write(res_json)
        elif self.path.startswith('/hello/'):
            self.send_response(405)
            self.send_error(405, "Method Not Allowed")
        elif self.path == '/test':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            res = {"message": "test is successful"}
            res_json = json.dumps(res).encode('utf-8')
            self.wfile.write(res_json)
        else:
            self.send_error(404, "Not Found")

    def do_POST(self):
        if self.path == '/hello':
            self.send_error(405, "Method Not Allowed")
        elif self.path.startswith('/hello/'):
            name = self.path.split('/')[2]
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            res = {"message": f"Hi, {name}."}
            res_json = json.dumps(res).encode('utf-8')
            self.wfile.write(res_json)
        elif self.path.startswith('/test'):
            parsed_url = urlparse(self.path)
            query_params = parse_qs(parsed_url.query)
            msg = query_params.get('msg', [None])[0]            

            if msg:
                self.send_response(200)
                self.send_header('Content-type', 'application/json')
                self.end_headers()
                res = {"message": msg}
                res_json = json.dumps(res).encode('utf-8')
                self.wfile.write(res_json)
            else:
                self.send_error(400, "Bad Request")
        else:
            self.send_error(404, "Not Found")

address = ('', 8090)
httpd = http.server.HTTPServer(address, My_Handler)
print('HTTP Server is running')
httpd.serve_forever()
