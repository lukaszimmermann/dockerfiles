from flask import Flask, request, send_from_directory, jsonify
import os
import json
from collections import defaultdict


# set the project root directory as the static folder, you can set others.
app = Flask(__name__)

FILES = 'files'

def remove_extension(filename):
    return '.'.join(filename.split('.')[:-1])

def get_groups():
    groups = defaultdict(list)
    files = [remove_extension(x).split('_') for x in os.listdir(FILES) if x.endswith('.json')]
    for f in files:
        groups[tuple(f[:3])].append(f[3])
    return  [ {'action': g[0], 'repository': g[1], 'tag': g[2], 'items': groups[g] } for g in groups.keys()]

@app.route('/<path:path>')
def send_js(path):
    return send_from_directory(FILES, path)

@app.route('/groups', methods = ['GET'])
def groups():
    return jsonify(get_groups())

if __name__ == "__main__":
    get_groups()
    app.run(host='0.0.0.0', port=6000)


