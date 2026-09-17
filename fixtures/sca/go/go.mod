// Deliberately vulnerable Go dependencies for SCA scanner testing.
module github.com/tigergate/fixture-go

go 1.20

require (
	github.com/dgrijalva/jwt-go v3.2.0+incompatible // CVE-2020-26160
	github.com/gin-gonic/gin v1.6.0 // CVE-2020-28483
	gopkg.in/yaml.v2 v2.2.2 // CVE-2019-11254
)
