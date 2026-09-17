// Deliberately insecure Node.js for SAST scanner testing. DO NOT run or reuse.
const express = require("express");
const { exec } = require("child_process");
const mysql = require("mysql");
const app = express();

// CWE-798: hard-coded secret
const JWT_SECRET = "hardcoded-jwt-secret-do-not-use";

app.get("/run", (req, res) => {
  // CWE-78: command injection
  exec("ls " + req.query.dir, (e, out) => res.send(out));
});

app.get("/user", (req, res) => {
  const conn = mysql.createConnection({ host: "localhost", user: "root", password: "root" });
  // CWE-89: SQL injection
  conn.query("SELECT * FROM users WHERE name = '" + req.query.name + "'", (e, r) => res.send(r));
});

app.get("/eval", (req, res) => {
  // CWE-95: code injection
  res.send(String(eval(req.query.x)));
});

app.get("/page", (req, res) => {
  // CWE-79: reflected XSS (unescaped user input in HTML)
  res.send("<h1>Hello " + req.query.name + "</h1>");
});

app.listen(3000);
