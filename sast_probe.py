# SAST diagnostic probe at repo ROOT (outside fixtures/) to test path handling.
# Deliberately vulnerable. If TigerGate SAST reports 0 even for THIS file,
# the SAST engine/language is not running -- not a path or fixture issue.
import os
import subprocess


def run(cmd):
    # CWE-78: OS command injection (obvious sink)
    os.system("echo " + cmd)
    subprocess.call("ping " + cmd, shell=True)


def query(user_input):
    # CWE-89: SQL injection via string concatenation
    sql = "SELECT * FROM users WHERE name = '" + user_input + "'"
    return sql


def evaluate(expr):
    # CWE-95: code injection
    return eval(expr)
