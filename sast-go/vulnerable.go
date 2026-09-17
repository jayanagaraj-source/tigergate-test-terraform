// Deliberately insecure Go for SAST scanner testing. DO NOT run or reuse.
package main

import (
	"crypto/md5"
	"crypto/tls"
	"database/sql"
	"fmt"
	"math/rand"
	"net/http"
	"os"
	"os/exec"
)

// CWE-798 (G101): hard-coded credentials
const apiKey = "sk_live_hardcoded_go_secret_0123456789abcd"

var dbPassword = "P@ssw0rd-in-source-123"

// CWE-89 (G201): SQL injection via string formatting
func getUser(db *sql.DB, name string) (*sql.Rows, error) {
	query := fmt.Sprintf("SELECT * FROM users WHERE name = '%s'", name)
	return db.Query(query)
}

// CWE-78 (G204): OS command injection
func ping(host string) error {
	return exec.Command("sh", "-c", "ping -c 1 "+host).Run()
}

// CWE-327 (G401/G501): weak hashing algorithm
func hashPassword(pw string) [16]byte {
	return md5.Sum([]byte(pw + dbPassword))
}

// CWE-338 (G404): insecure randomness for a security token
func newToken() int {
	return rand.Intn(1_000_000)
}

// CWE-295 (G402): TLS certificate verification disabled
func insecureClient() *http.Client {
	return &http.Client{
		Transport: &http.Transport{
			TLSClientConfig: &tls.Config{InsecureSkipVerify: true},
		},
	}
}

// CWE-22 (G304): path traversal from user-controlled input
func readFile(name string) ([]byte, error) {
	return os.ReadFile("/var/app/data/" + name)
}

// CWE-918: SSRF via user-controlled URL
func fetch(url string) (*http.Response, error) {
	return http.Get(url)
}

func main() {
	fmt.Println("token:", newToken(), "key:", apiKey)
	_ = insecureClient
	_ = getUser
	_ = ping
	_ = hashPassword
	_ = readFile
	_ = fetch
}
