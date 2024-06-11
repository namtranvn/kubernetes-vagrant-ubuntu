from flask import Flask, request, jsonify
import base64
import jsonpatch

app = Flask(__name__)

@app.route('/', methods=['GET'])
def hello():
    return "Hello"

if __name__ == '__main__':
    app.run(debug=False, host='0.0.0.0', port=80)