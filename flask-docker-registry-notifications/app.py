from flask import Flask, request, send_from_directory

# set the project root directory as the static folder, you can set others.
app = Flask(__name__)

@app.route('/<path:path>')
def send_js(path):
    return send_from_directory('files', path)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)


