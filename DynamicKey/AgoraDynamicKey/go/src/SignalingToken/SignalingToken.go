package SignalingToken

import (
	"fmt"
	"crypto/md5"
	"encoding/hex"
)

func GenerateSignalingToken(account, appID, appCertificate string, expiredTsInSeconds uint32) (string) {

	version := "1"
	expired := fmt.Sprint(expiredTsInSeconds)
	content := account + appID + appCertificate + expired

	hasher := md5.New()
    hasher.Write([]byte(content))
	md5sum := hex.EncodeToString(hasher.Sum(nil))

	result := fmt.Sprintf("%s:%s:%s:%s", version, appID, expired, md5sum)
	return result
}
