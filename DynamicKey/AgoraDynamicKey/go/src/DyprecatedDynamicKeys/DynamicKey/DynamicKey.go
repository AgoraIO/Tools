package DynamicKey

import (
	"crypto/hmac"
	"crypto/sha1"
	"encoding/hex"
	"fmt"
	"strings"
)

func Generate(appID, appCertificate, channelName string, unixTs, randomInt uint32) (string) {
    return generateDynamicKey(appID, appCertificate, channelName, unixTs, randomInt)
}

func generateDynamicKey(appID, appCertificate, channelName string, unixTs, randomInt uint32) (string) {
	unixTsStr := fmt.Sprintf("%010d", unixTs)
	randomIntStr := fmt.Sprintf("%08x", randomInt)
	signature := generateSignature(appID, appCertificate, channelName, unixTsStr, randomIntStr)
	buffer := strings.Join([]string{signature, appID, unixTsStr, randomIntStr}, "")
	return buffer
}

func generateSignature(appID, appCertificate, channelName, unixTsStr, randomIntStr string) (string) {
	buffer := strings.Join([]string{appID, unixTsStr, randomIntStr, channelName}, "")
	signature := hmac.New(sha1.New, []byte(appCertificate))
	signature.Write([]byte(buffer))
	return hex.EncodeToString(signature.Sum(nil))
}
