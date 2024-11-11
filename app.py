from flask import Flask, render_template, request
import os
import socket

app = Flask(__name__)

@app.route("/")
def hello():
    name = os.getenv("NAME", "world")
    hostname = socket.gethostname()
    client_ip = request.remote_addr
    return render_template("index.html", name=name, hostname=hostname, client_ip=client_ip)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)