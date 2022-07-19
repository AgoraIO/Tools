package DynamicKey4

import (
	"crypto/hmac"
	"crypto/sha1"
	"encoding/hex"
	"fmt"
	"strings"
)

func GeneratePublicSharingKey(appID, appCertificate, channelName string, unixTs, randomInt, uid, expiredTs uint32) (string) {
    return generateDynamicKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs, "APSS")
}

func GenerateRecordingKey(appID, appCertificate, channelName string, unixTs, randomInt, uid, expiredTs uint32) (string) {
    return generateDynamicKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs, "ARS")
}

func GenerateMediaChannelKey(appID, appCertificate, channelName string, unixTs, randomInt, uid, expiredTs uint32) (string) {
    return generateDynamicKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs, "ACS")
}

func generateDynamicKey(appID, appCertificate, channelName string, unixTs, randomInt, uid, expiredTs uint32, serviceType string) (string) {
    version := "004"
	unixTsStr := fmt.Sprintf("%010d", unixTs)
	randomIntStr := fmt.Sprintf("%08x", randomInt)
	uidStr := fmt.Sprintf("%010d", uid)
	expiredTsStr := fmt.Sprintf("%010d", expiredTs)
	signature := generateSignature(appID, appCertificate, channelName, unixTsStr, randomIntStr, uidStr, expiredTsStr, serviceType)
	buffer := strings.Join([]string{version, signature, appID, unixTsStr, randomIntStr, expiredTsStr}, "")
	return buffer
}

func generateSignature(appID, appCertificate, channelName, unixTsStr, randomIntStr, uidStr, expiredTsStr, serviceType string) (string) {
	buffer := strings.Join([]string{serviceType, appID, unixTsStr, randomIntStr, channelName, uidStr, expiredTsStr}, "")
	signature := hmac.New(sha1.New, []byte(appCertificate))
	signature.Write([]byte(buffer))
	return hex.EncodeToString(signature.Sum(nil))
}
