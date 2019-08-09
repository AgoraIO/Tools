package DynamicKey3

import (
	"crypto/hmac"
	"crypto/sha1"
	"encoding/hex"
	"fmt"
	"strings"
)

func Generate(appID, appCertificate, channelName string, unixTs, randomInt, uid, expiredTs uint32) (string) {
    return generateDynamicKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs)
}

func generateDynamicKey(appID, appCertificate, channelName string, unixTs, randomInt, uid, expiredTs uint32) (string) {
    version := "003"
	unixTsStr := fmt.Sprintf("%010d", unixTs)
	randomIntStr := fmt.Sprintf("%08x", randomInt)
	uidStr := fmt.Sprintf("%010d", uid)
	expiredTsStr := fmt.Sprintf("%010d", expiredTs)
	signature := generateSignature(appID, appCertificate, channelName, unixTsStr, randomIntStr, uidStr, expiredTsStr)
	buffer := strings.Join([]string{version, signature, appID, unixTsStr, randomIntStr, uidStr, expiredTsStr}, "")
	return buffer
}

func generateSignature(appID, appCertificate, channelName, unixTsStr, randomIntStr, uidStr, expiredTsStr string) (string) {
	buffer := strings.Join([]string{appID, unixTsStr, randomIntStr, channelName, uidStr, expiredTsStr}, "")
	signature := hmac.New(sha1.New, []byte(appCertificate))
	signature.Write([]byte(buffer))
	return hex.EncodeToString(signature.Sum(nil))
}
