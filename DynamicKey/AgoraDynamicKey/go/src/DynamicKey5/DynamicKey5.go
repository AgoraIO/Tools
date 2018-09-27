package DynamicKey5

import (
	"bytes"
	"crypto/hmac"
	"crypto/sha1"
	"encoding/base64"
	"encoding/binary"
	"encoding/hex"
	"io"
	"sort"
	"strings"
)

const (
	MEDIA_CHANNEL_SERVICE  = 1
	RECORDING_SERVICE      = 2
	PUBLIC_SHARING_SERVICE = 3
	IN_CHANNEL_PERMISSION  = 4
)

//extra key
const (
	ALLOW_UPLOAD_IN_CHANNEL = 1
)

//permission
var (
	NoUpload         = "0"
	AudioVideoUpload = "3"
)

func GeneratePublicSharingKey(appID, appCertificate, channelName string, unixTs, randomInt, uid, expiredTs uint32) (string, error) {
	extra := map[uint16]string{}
	return generateDynamicKey(PUBLIC_SHARING_SERVICE, appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs, extra)
}

func GenerateRecordingKey(appID, appCertificate, channelName string, unixTs, randomInt, uid, expiredTs uint32) (string, error) {
	extra := map[uint16]string{}
	return generateDynamicKey(RECORDING_SERVICE, appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs, extra)
}

func GenerateMediaChannelKey(appID, appCertificate, channelName string, unixTs, randomInt, uid, expiredTs uint32) (string, error) {
	extra := map[uint16]string{}
	return generateDynamicKey(MEDIA_CHANNEL_SERVICE, appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs, extra)
}

func GenerateInChannelPermissionKey(appID, appCertificate, channelName string, unixTs, randomInt, uid, expiredTs uint32, permission string) (string, error) {
	extra := map[uint16]string{}
	extra[uint16(ALLOW_UPLOAD_IN_CHANNEL)] = permission
	return generateDynamicKey(IN_CHANNEL_PERMISSION, appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs, extra)
}

//extra key should be sorted.
func generateDynamicKey(serviceType uint16, appID, appCertificate, channelName string, unixTs, randomInt, uid, expiredTs uint32, extra map[uint16]string) (string, error) {
	dkey := ""
	version := "005"
	signature, err := generateSignature(serviceType, appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs, extra)
	if err != nil {
		return dkey, err
	}

	buf := new(bytes.Buffer)
	if err := packUint16(buf, serviceType); err != nil {
		return dkey, err
	}

	if err := packString(buf, signature); err != nil {

		return dkey, err
	}
	if err := packHexString(buf, appID); err != nil {
		return dkey, err
	}

	if err := packUint32(buf, unixTs); err != nil {
		return dkey, err
	}

	if err := packUint32(buf, randomInt); err != nil {
		return dkey, err
	}

	if err := packUint32(buf, expiredTs); err != nil {
		return dkey, err
	}

	if err := packExtra(buf, extra); err != nil {
		return dkey, err
	}
	dkey = version + base64.StdEncoding.EncodeToString(buf.Bytes())
	return dkey, nil
}

func generateSignature(serviceType uint16, appID, appCertificate, channelName string, unixTs, randomInt, uid, expiredTs uint32, extra map[uint16]string) (string, error) {
	var sigStr string
	buf := new(bytes.Buffer)
	if err := packUint16(buf, serviceType); err != nil {
		return sigStr, err
	}

	if err := packHexString(buf, appID); err != nil {
		return sigStr, err
	}

	if err := packUint32(buf, unixTs); err != nil {
		return sigStr, err
	}

	if err := packUint32(buf, randomInt); err != nil {
		return sigStr, err
	}

	if err := packString(buf, channelName); err != nil {
		return sigStr, err
	}

	if err := packUint32(buf, uid); err != nil {
		return sigStr, err
	}

	if err := packUint32(buf, expiredTs); err != nil {
		return sigStr, err
	}

	if err := packExtra(buf, extra); err != nil {
		return sigStr, err
	}
	var cert []byte
	if _c, err := hex.DecodeString(appCertificate); err != nil {
		return sigStr, err
	} else {
		cert = _c
	}
	signature := hmac.New(sha1.New, cert)
	signature.Write(buf.Bytes())
	sigStr = strings.ToUpper(hex.EncodeToString(signature.Sum(nil)))
	return sigStr, nil
}

func packUint16(w io.Writer, n uint16) error {
	return binary.Write(w, binary.LittleEndian, n)
}

func packUint32(w io.Writer, n uint32) error {
	return binary.Write(w, binary.LittleEndian, n)
}

func packString(w io.Writer, s string) error {
	err := packUint16(w, uint16(len(s)))
	if err != nil {
		return err
	}
	_, err = w.Write([]byte(s))
	return err
}

func packHexString(w io.Writer, s string) error {
	b, err := hex.DecodeString(s)
	if err != nil {
		return err
	}
	return packString(w, string(b))
}

func packExtra(w io.Writer, extra map[uint16]string) error {
	keys := []int{}
	if err := packUint16(w, uint16(len(extra))); err != nil {
		return err
	}
	for k := range extra {
		keys = append(keys, int(k))
	}
	//should sorted keys
	sort.Ints(keys)

	for _, k := range keys {
		v := extra[uint16(k)]
		if err := packUint16(w, uint16(k)); err != nil {
			return err
		}
		if err := packString(w, v); err != nil {
			return err
		}
	}
	return nil
}
