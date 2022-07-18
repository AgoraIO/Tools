package accesstoken2

import (
	"bytes"
	"crypto/hmac"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"fmt"
	"io"
	"time"
)

const (
	Version       = "007"
	VersionLength = 3

	// Service type
	ServiceTypeRtc       = 1
	ServiceTypeRtm       = 2
	ServiceTypeFpa       = 4
	ServiceTypeChat      = 5
	ServiceTypeEducation = 7

	// Rtc
	PrivilegeJoinChannel        = 1
	PrivilegePublishAudioStream = 2
	PrivilegePublishVideoStream = 3
	PrivilegePublishDataStream  = 4

	// Rtm
	// Fpa
	PrivilegeLogin = 1

	// Chat
	PrivilegeChatUser = 1
	PrivilegeChatApp  = 2

	// Education
	PrivilegeEducationRoomUser = 1
	PrivilegeEducationUser     = 2
	PrivilegeEducationApp      = 3
)

type IService interface {
	getServiceType() uint16
	Pack(io.Writer) error
	UnPack(io.Reader) error
}

type Service struct {
	Privileges map[uint16]uint32
	Type       uint16
}

func NewService(serviceType uint16) (service *Service) {
	service = &Service{Privileges: make(map[uint16]uint32), Type: serviceType}
	return
}

func (service *Service) AddPrivilege(privilege uint16, expire uint32) {
	service.Privileges[privilege] = expire
}

func (service *Service) getServiceType() uint16 {
	return service.Type
}

func (service *Service) Pack(w io.Writer) (err error) {
	err = service.packType(w)
	if err != nil {
		return
	}
	err = service.packPrivileges(w)
	return
}

func (service *Service) UnPack(r io.Reader) (err error) {
	service.Privileges, err = unPackMapUint32(r)
	return
}

func (service *Service) packPrivileges(w io.Writer) error {
	return packMapUint32(w, service.Privileges)
}

func (service *Service) packType(w io.Writer) error {
	return packUint16(w, service.Type)
}

type ServiceRtc struct {
	*Service
	ChannelName string
	Uid         string
}

func NewServiceRtc(channelName string, uid string) (serviceRtc *ServiceRtc) {
	serviceRtc = &ServiceRtc{ChannelName: channelName, Service: NewService(ServiceTypeRtc), Uid: uid}
	return
}

func (serviceRtc *ServiceRtc) Pack(w io.Writer) (err error) {
	err = serviceRtc.Service.Pack(w)
	if err != nil {
		return
	}
	err = packString(w, serviceRtc.ChannelName)
	if err != nil {
		return
	}
	err = packString(w, serviceRtc.Uid)
	return
}

func (serviceRtc *ServiceRtc) UnPack(r io.Reader) (err error) {
	err = serviceRtc.Service.UnPack(r)
	if err != nil {
		return
	}
	serviceRtc.ChannelName, err = unPackString(r)
	serviceRtc.Uid, err = unPackString(r)
	return
}

type ServiceRtm struct {
	*Service
	UserId string
}

func NewServiceRtm(userId string) (serviceRtm *ServiceRtm) {
	serviceRtm = &ServiceRtm{UserId: userId, Service: NewService(ServiceTypeRtm)}
	return
}

func (serviceRtm *ServiceRtm) Pack(w io.Writer) (err error) {
	err = serviceRtm.Service.Pack(w)
	if err != nil {
		return
	}
	err = packString(w, serviceRtm.UserId)
	return
}

func (serviceRtm *ServiceRtm) UnPack(r io.Reader) (err error) {
	err = serviceRtm.Service.UnPack(r)
	if err != nil {
		return
	}
	serviceRtm.UserId, err = unPackString(r)
	return
}

type ServiceFpa struct {
	*Service
}

func NewServiceFpa() (serviceFpa *ServiceFpa) {
	serviceFpa = &ServiceFpa{Service: NewService(ServiceTypeFpa)}
	return
}

func (serviceFpa *ServiceFpa) Pack(w io.Writer) (err error) {
	err = serviceFpa.Service.Pack(w)
	if err != nil {
		return
	}
	return
}

func (serviceFpa *ServiceFpa) UnPack(r io.Reader) (err error) {
	err = serviceFpa.Service.UnPack(r)
	if err != nil {
		return
	}
	return
}

type ServiceChat struct {
	*Service
	UserId string
}

func NewServiceChat(userId string) (serviceChat *ServiceChat) {
	serviceChat = &ServiceChat{Service: NewService(ServiceTypeChat), UserId: userId}
	return
}

func (serviceChat *ServiceChat) Pack(w io.Writer) (err error) {
	err = serviceChat.Service.Pack(w)
	if err != nil {
		return
	}
	err = packString(w, serviceChat.UserId)
	return
}

func (serviceChat *ServiceChat) UnPack(r io.Reader) (err error) {
	err = serviceChat.Service.UnPack(r)
	if err != nil {
		return
	}
	serviceChat.UserId, err = unPackString(r)
	return
}

type ServiceEducation struct {
	*Service
	RoomUuid string
	UserUuid string
	Role     int16
}

func NewServiceEducation(roomUuid string, userUuid string, role int16) (serviceEducation *ServiceEducation) {
	serviceEducation = &ServiceEducation{Service: NewService(ServiceTypeEducation), RoomUuid: roomUuid, UserUuid: userUuid, Role: role}
	return
}

func (serviceEducation *ServiceEducation) Pack(w io.Writer) (err error) {
	err = serviceEducation.Service.Pack(w)
	if err != nil {
		return
	}
	err = packString(w, serviceEducation.RoomUuid)
	if err != nil {
		return
	}
	err = packString(w, serviceEducation.UserUuid)
	if err != nil {
		return
	}
	err = packInt16(w, serviceEducation.Role)
	return
}

func (serviceEducation *ServiceEducation) UnPack(r io.Reader) (err error) {
	err = serviceEducation.Service.UnPack(r)
	if err != nil {
		return
	}
	serviceEducation.RoomUuid, err = unPackString(r)
	serviceEducation.UserUuid, err = unPackString(r)
	serviceEducation.Role, err = unPackInt16(r)
	return
}

type AccessToken struct {
	AppCert  string
	AppId    string
	Expire   uint32
	IssueTs  uint32
	Salt     uint32
	Services map[uint16]IService
}

func NewAccessToken(appId string, appCert string, expire uint32) (accessToken *AccessToken) {
	issueTs := uint32(time.Now().Unix())
	salt := uint32(getRand(1, 99999999))
	accessToken = &AccessToken{AppCert: appCert, AppId: appId, Expire: expire, IssueTs: issueTs, Salt: salt, Services: make(map[uint16]IService)}
	return
}

func CreateAccessToken() (accessToken *AccessToken) {
	return NewAccessToken("", "", 900)
}

func (accessToken *AccessToken) AddService(service IService) {
	accessToken.Services[service.getServiceType()] = service
}

func (accessToken *AccessToken) Build() (res string, err error) {
	recoverException()

	if !isUuid(accessToken.AppId) || !isUuid(accessToken.AppCert) {
		return "", errors.New("check appId or appCertificate")
	}

	buf := new(bytes.Buffer)
	if err = packString(buf, accessToken.AppId); err != nil {
		return
	}
	if err = packUint32(buf, accessToken.IssueTs); err != nil {
		return
	}
	if err = packUint32(buf, accessToken.Expire); err != nil {
		return
	}
	if err = packUint32(buf, accessToken.Salt); err != nil {
		return
	}
	if err = packUint16(buf, uint16(len(accessToken.Services))); err != nil {
		return
	}

	// Sign
	var sign []byte
	sign, err = accessToken.getSign()

	if err != nil {
		return
	}

	// Pack services in definite order
	serviceTypes := []uint16{ServiceTypeRtc, ServiceTypeRtm, ServiceTypeFpa, ServiceTypeChat, ServiceTypeEducation}
	for _, serviceType := range serviceTypes {
		if service, ok := accessToken.Services[serviceType]; ok {
			err = service.Pack(buf)
			if err != nil {
				return
			}
		}
	}

	// Signature
	hSign := hmac.New(sha256.New, sign)
	hSign.Write(buf.Bytes())
	signature := hSign.Sum(nil)

	bufContent := new(bytes.Buffer)
	if err = packString(bufContent, string(signature)); err != nil {
		return
	}
	bufContent.Write(buf.Bytes())

	res = getVersion() + base64EncodeStr(compressZlib(bufContent.Bytes()))
	return
}

func (accessToken *AccessToken) Parse(token string) (res bool, err error) {
	recoverException()

	version := token[:VersionLength]
	if version != getVersion() {
		return
	}

	var decodeByte []byte
	if decodeByte, err = base64DecodeStr(token[VersionLength:]); err != nil {
		return
	}
	buffer := bytes.NewReader(decompressZlib(decodeByte))
	// signature
	_, err = unPackString(buffer)
	if accessToken.AppId, err = unPackString(buffer); err != nil {
		return
	}
	if accessToken.IssueTs, err = unPackUint32(buffer); err != nil {
		return
	}
	if accessToken.Expire, err = unPackUint32(buffer); err != nil {
		return
	}
	if accessToken.Salt, err = unPackUint32(buffer); err != nil {
		return
	}

	var serviceNum uint16
	if serviceNum, err = unPackUint16(buffer); err != nil {
		return
	}
	var serviceType uint16
	for i := 0; i < int(serviceNum); i++ {
		if serviceType, err = unPackUint16(buffer); err != nil {
			return
		}
		service := accessToken.newService(serviceType)
		if err = service.UnPack(buffer); err != nil {
			return
		}
		accessToken.Services[serviceType] = service
	}

	return true, nil
}

func (accessToken *AccessToken) getSign() (sign []byte, err error) {
	// IssueTs
	bufIssueTs := new(bytes.Buffer)
	err = packUint32(bufIssueTs, accessToken.IssueTs)
	if err != nil {
		return
	}
	hIssueTs := hmac.New(sha256.New, bufIssueTs.Bytes())
	hIssueTs.Write([]byte(accessToken.AppCert))

	// Salt
	bufSalt := new(bytes.Buffer)
	err = packUint32(bufSalt, accessToken.Salt)
	if err != nil {
		return
	}
	hSalt := hmac.New(sha256.New, bufSalt.Bytes())
	hSalt.Write([]byte(hIssueTs.Sum(nil)))
	sign = hSalt.Sum(nil)
	return
}

func (accessToken *AccessToken) newService(serviceType uint16) (service IService) {
	switch serviceType {
	case ServiceTypeRtc:
		service = NewServiceRtc("", "")
	case ServiceTypeRtm:
		service = NewServiceRtm("")
	case ServiceTypeFpa:
		service = NewServiceFpa()
	case ServiceTypeChat:
		service = NewServiceChat("")
	case ServiceTypeEducation:
		service = NewServiceEducation("", "", -1)
	default:
		panic(fmt.Sprintf("new service failed: unknown service type `%v`", serviceType))
	}
	return
}

func GetUidStr(uid uint32) string {
	if uid == 0 {
		return ""
	}
	return fmt.Sprintf("%d", uid)
}

func getVersion() string {
	return Version
}

func isUuid(s string) (res bool) {
	if len(s) != 32 {
		return
	}
	if _, err := hex.DecodeString(s); err != nil {
		return
	}
	return true
}
