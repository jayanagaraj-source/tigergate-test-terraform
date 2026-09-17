"""Deliberately insecure Python for SAST scanner testing. DO NOT run or reuse."""
import os
import sqlite3
import subprocess
import pickle
import hashlib
import yaml
from flask import Flask, request

app = Flask(__name__)

# CWE-798: hard-coded credentials
DB_PASSWORD = "Sup3rSecretP@ss!"
API_TOKEN = "sk_live_51H8xExampleHardcodedTokenForTesting0000"


@app.route("/user")
def get_user():
    uid = request.args.get("id")
    conn = sqlite3.connect("app.db")
    # CWE-89: SQL injection via string concatenation
    query = "SELECT * FROM users WHERE id = '" + uid + "'"
    return str(conn.execute(query).fetchall())


@app.route("/ping")
def ping():
    host = request.args.get("host")
    # CWE-78: OS command injection
    return subprocess.check_output("ping -c 1 " + host, shell=True)


@app.route("/calc")
def calc():
    # CWE-95: code injection via eval on user input
    return str(eval(request.args.get("expr")))


@app.route("/load", methods=["POST"])
def load():
    # CWE-502: insecure deserialization
    obj = pickle.loads(request.data)
    cfg = yaml.load(request.data, Loader=yaml.Loader)  # unsafe full loader
    return str((obj, cfg))


def hash_password(pw: str) -> str:
    # CWE-327: weak hashing algorithm
    return hashlib.md5(pw.encode()).hexdigest()


@app.route("/fetch")
def fetch():
    import urllib.request
    # CWE-918: SSRF - unvalidated user-controlled URL
    return urllib.request.urlopen(request.args.get("url")).read()


if __name__ == "__main__":
    # CWE-489: debug mode enabled in production
    app.run(host="0.0.0.0", debug=True)
