from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def index():
    files = []
    for root, dirs, filenames in os.walk('/mnt/backups'):
        for f in filenames:
            files.append(os.path.join(root, f))
    return '<h2>Backups:</h2><br>' + '<br>'.join(files)

@app.route('/alertas')
def alertas():
    try:
        with open('/home/alertas_detectadas/log_alertas.txt') as f:
            return '<h2>Alertas:</h2><br>' + f.read().replace('\n', '<br>')
    except FileNotFoundError:
        return "No se han detectado alertas."

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)

