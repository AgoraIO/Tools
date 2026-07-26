package accesstoken2

import (
	"bytes"
	"crypto/hmac"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"fmt"
	"io"
	"sort"
	"time"
)

const (
	Version       = "007"
	VersionLength = 3

	// Service type
	ServiceTypeRtc       = 1
	ServiceTypeRtm       = 2
	ServiceTypeStreaming = 3
	ServiceTypeFpa       = 4
	ServiceTypeChat      = 5
	ServiceTypeFCdn      = 6
	ServiceTypeApaas     = 7
	ServiceTypeRtm2      = 8

	// Rtc
	PrivilegeJoinChannel        = 1
	PrivilegePublishAudioStream = 2
	PrivilegePublishVideoStream = 3
	PrivilegePublishDataStream  = 4

	// Rtm
	// Fpa
	PrivilegeLogin = 1

	// Streaming
	PrivilegeStreamingPublishMixStream = 1
	PrivilegeStreamingPublishRawStream = 2

	// FCDN
	PrivilegeFCdnPublish = 1
	PrivilegeFCdnPlay    = 2

	// Chat
	PrivilegeChatUser = 1
	PrivilegeChatApp  = 2

	// Apaas
	PrivilegeApaasRoomUser = 1
	PrivilegeApaasUser     = 2
	PrivilegeApaasApp      = 3

	// RTM2 resource types
	Rtm2ResourceMessageChannels = 0
	Rtm2ResourceStreamChannels  = 1
	Rtm2ResourceGroupChannels   = 2
	Rtm2ResourceServerGroups    = 3
	Rtm2ResourceUsers           = 4

	// RTM2 permission types
	Rtm2PermissionRead  = 0
	Rtm2PermissionWrite = 1
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

// NewService creates a service with the specified type and an empty privilege map.
func NewService(serviceType uint16) (service *Service) {
	service = &Service{Privileges: make(map[uint16]uint32), Type: serviceType}
	return
}

// AddPrivilege sets the expiration time for a service privilege.
func (service *Service) AddPrivilege(privilege uint16, expire uint32) {
	service.Privileges[privilege] = expire
}

// getServiceType returns the numeric service type.
func (service *Service) getServiceType() uint16 {
	return service.Type
}

// Pack writes the service type and privileges.
func (service *Service) Pack(w io.Writer) (err error) {
	err = service.packType(w)
	if err != nil {
		return
	}
	err = service.packPrivileges(w)
	return
}

// UnPack reads the service privileges after the type has been consumed.
func (service *Service) UnPack(r io.Reader) (err error) {
	service.Privileges, err = unPackMapUint32(r)
	return
}

// packPrivileges writes the service privilege map.
func (service *Service) packPrivileges(w io.Writer) error {
	return packMapUint32(w, service.Privileges)
}

// packType writes the numeric service type.
func (service *Service) packType(w io.Writer) error {
	return packUint16(w, service.Type)
}

type ServiceRtc struct {
	*Service
	ChannelName string
	Uid         string
}

// NewServiceRtc creates an RTC service for a channel and user ID.
func NewServiceRtc(channelName string, uid string) (serviceRtc *ServiceRtc) {
	serviceRtc = &ServiceRtc{ChannelName: channelName, Service: NewService(ServiceTypeRtc), Uid: uid}
	return
}

// Pack writes the RTC service, channel name, and user ID.
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

// UnPack reads the RTC privileges, channel name, and user ID.
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

type ServiceStreaming struct {
	*Service
	ChannelName string
	Account     string
}

// NewServiceStreaming creates a Streaming service for a channel and user account.
func NewServiceStreaming(channelName string, account string) *ServiceStreaming {
	return &ServiceStreaming{Service: NewService(ServiceTypeStreaming), ChannelName: channelName, Account: account}
}

// NewServiceStreamingWithUid creates a Streaming service with a numeric user ID.
func NewServiceStreamingWithUid(channelName string, uid uint32) *ServiceStreaming {
	return NewServiceStreaming(channelName, GetUidStr(uid))
}

// Pack writes the Streaming service, channel name, and user account.
func (serviceStreaming *ServiceStreaming) Pack(w io.Writer) (err error) {
	if err = serviceStreaming.Service.Pack(w); err != nil {
		return
	}
	if err = packString(w, serviceStreaming.ChannelName); err != nil {
		return
	}
	err = packString(w, serviceStreaming.Account)
	return
}

// UnPack reads the Streaming privileges, channel name, and user account.
func (serviceStreaming *ServiceStreaming) UnPack(r io.Reader) (err error) {
	if err = serviceStreaming.Service.UnPack(r); err != nil {
		return
	}
	if serviceStreaming.ChannelName, err = unPackString(r); err != nil {
		return
	}
	serviceStreaming.Account, err = unPackString(r)
	return
}

// NewServiceRtm creates an RTM service for a user ID.
func NewServiceRtm(userId string) (serviceRtm *ServiceRtm) {
	serviceRtm = &ServiceRtm{UserId: userId, Service: NewService(ServiceTypeRtm)}
	return
}

// Pack writes the RTM service and user ID.
func (serviceRtm *ServiceRtm) Pack(w io.Writer) (err error) {
	err = serviceRtm.Service.Pack(w)
	if err != nil {
		return
	}
	err = packString(w, serviceRtm.UserId)
	return
}

// UnPack reads the RTM privileges and user ID.
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

// NewServiceFpa creates an FPA service.
func NewServiceFpa() (serviceFpa *ServiceFpa) {
	serviceFpa = &ServiceFpa{Service: NewService(ServiceTypeFpa)}
	return
}

// Pack writes the FPA service and privileges.
func (serviceFpa *ServiceFpa) Pack(w io.Writer) (err error) {
	err = serviceFpa.Service.Pack(w)
	if err != nil {
		return
	}
	return
}

// UnPack reads the FPA privileges.
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

type ServiceFCdn struct {
	*Service
	ChannelName string
	Account     string
}

// NewServiceFCdn creates an FCDN service for a channel and user account.
func NewServiceFCdn(channelName string, account string) *ServiceFCdn {
	return &ServiceFCdn{Service: NewService(ServiceTypeFCdn), ChannelName: channelName, Account: account}
}

// NewServiceFCdnWithUid creates an FCDN service with a numeric user ID.
func NewServiceFCdnWithUid(channelName string, uid uint32) *ServiceFCdn {
	return NewServiceFCdn(channelName, GetUidStr(uid))
}

// Pack writes the FCDN service, channel name, and user account.
func (serviceFCdn *ServiceFCdn) Pack(w io.Writer) (err error) {
	if err = serviceFCdn.Service.Pack(w); err != nil {
		return
	}
	if err = packString(w, serviceFCdn.ChannelName); err != nil {
		return
	}
	err = packString(w, serviceFCdn.Account)
	return
}

// UnPack reads the FCDN privileges, channel name, and user account.
func (serviceFCdn *ServiceFCdn) UnPack(r io.Reader) (err error) {
	if err = serviceFCdn.Service.UnPack(r); err != nil {
		return
	}
	if serviceFCdn.ChannelName, err = unPackString(r); err != nil {
		return
	}
	serviceFCdn.Account, err = unPackString(r)
	return
}

// NewServiceChat creates a Chat service for a user ID.
func NewServiceChat(userId string) (serviceChat *ServiceChat) {
	serviceChat = &ServiceChat{Service: NewService(ServiceTypeChat), UserId: userId}
	return
}

// Pack writes the Chat service and user ID.
func (serviceChat *ServiceChat) Pack(w io.Writer) (err error) {
	err = serviceChat.Service.Pack(w)
	if err != nil {
		return
	}
	err = packString(w, serviceChat.UserId)
	return
}

// UnPack reads the Chat privileges and user ID.
func (serviceChat *ServiceChat) UnPack(r io.Reader) (err error) {
	err = serviceChat.Service.UnPack(r)
	if err != nil {
		return
	}
	serviceChat.UserId, err = unPackString(r)
	return
}

type ServiceApaas struct {
	*Service
	RoomUuid string
	UserUuid string
	Role     int16
}

type Rtm2Permissions struct {
	Details map[uint16]map[uint16][]string
}

// NewRtm2Permissions creates an empty RTM2 permission set.
func NewRtm2Permissions() *Rtm2Permissions {
	return &Rtm2Permissions{Details: make(map[uint16]map[uint16][]string)}
}

// Add adds or replaces resources for an RTM2 resource and permission type.
func (permissions *Rtm2Permissions) Add(resourceType uint16, permissionType uint16, resources []string) {
	if permissions.Details[resourceType] == nil {
		permissions.Details[resourceType] = make(map[uint16][]string)
	}
	permissions.Details[resourceType][permissionType] = append([]string(nil), resources...)
}

type ServiceRtm2 struct {
	*Service
	UserId      string
	Permissions *Rtm2Permissions
}

// NewServiceRtm2 creates an RTM2 service with resource-level permissions.
func NewServiceRtm2(userId string, permissions *Rtm2Permissions) *ServiceRtm2 {
	if permissions == nil {
		permissions = NewRtm2Permissions()
	}
	return &ServiceRtm2{Service: NewService(ServiceTypeRtm2), UserId: userId, Permissions: permissions}
}

// Pack writes the RTM2 service, user ID, and resource permissions.
func (serviceRtm2 *ServiceRtm2) Pack(w io.Writer) (err error) {
	if err = serviceRtm2.Service.Pack(w); err != nil {
		return
	}
	if err = packString(w, serviceRtm2.UserId); err != nil {
		return
	}

	resourceTypes := make([]int, 0, len(serviceRtm2.Permissions.Details))
	for resourceType := range serviceRtm2.Permissions.Details {
		resourceTypes = append(resourceTypes, int(resourceType))
	}
	sort.Ints(resourceTypes)
	if err = packUint16(w, uint16(len(resourceTypes))); err != nil {
		return
	}

	for _, resourceTypeValue := range resourceTypes {
		resourceType := uint16(resourceTypeValue)
		if err = packUint16(w, resourceType); err != nil {
			return
		}

		permissionMap := serviceRtm2.Permissions.Details[resourceType]
		permissionTypes := make([]int, 0, len(permissionMap))
		for permissionType := range permissionMap {
			permissionTypes = append(permissionTypes, int(permissionType))
		}
		sort.Ints(permissionTypes)
		if err = packUint16(w, uint16(len(permissionTypes))); err != nil {
			return
		}

		for _, permissionTypeValue := range permissionTypes {
			permissionType := uint16(permissionTypeValue)
			resources := permissionMap[permissionType]
			if err = packUint16(w, permissionType); err != nil {
				return
			}
			if err = packUint16(w, uint16(len(resources))); err != nil {
				return
			}
			for _, resource := range resources {
				if err = packString(w, resource); err != nil {
					return
				}
			}
		}
	}
	return
}

// UnPack reads the RTM2 privileges, user ID, and resource permissions.
func (serviceRtm2 *ServiceRtm2) UnPack(r io.Reader) (err error) {
	if err = serviceRtm2.Service.UnPack(r); err != nil {
		return
	}
	if serviceRtm2.UserId, err = unPackString(r); err != nil {
		return
	}

	serviceRtm2.Permissions = NewRtm2Permissions()
	var resourceCount uint16
	if resourceCount, err = unPackUint16(r); err != nil {
		return
	}
	for i := uint16(0); i < resourceCount; i++ {
		var resourceType uint16
		var permissionCount uint16
		if resourceType, err = unPackUint16(r); err != nil {
			return
		}
		if permissionCount, err = unPackUint16(r); err != nil {
			return
		}
		for j := uint16(0); j < permissionCount; j++ {
			var permissionType uint16
			var resourceListCount uint16
			if permissionType, err = unPackUint16(r); err != nil {
				return
			}
			if resourceListCount, err = unPackUint16(r); err != nil {
				return
			}
			resources := make([]string, 0, resourceListCount)
			for k := uint16(0); k < resourceListCount; k++ {
				var resource string
				if resource, err = unPackString(r); err != nil {
					return
				}
				resources = append(resources, resource)
			}
			serviceRtm2.Permissions.Add(resourceType, permissionType, resources)
		}
	}
	return
}

// NewServiceApaas creates an APaaS service for a room, user, and role.
func NewServiceApaas(roomUuid string, userUuid string, role int16) (serviceApaas *ServiceApaas) {
	serviceApaas = &ServiceApaas{Service: NewService(ServiceTypeApaas), RoomUuid: roomUuid, UserUuid: userUuid, Role: role}
	return
}

// Pack writes the APaaS service, room, user, and role.
func (serviceApaas *ServiceApaas) Pack(w io.Writer) (err error) {
	err = serviceApaas.Service.Pack(w)
	if err != nil {
		return
	}
	err = packString(w, serviceApaas.RoomUuid)
	if err != nil {
		return
	}
	err = packString(w, serviceApaas.UserUuid)
	if err != nil {
		return
	}
	err = packInt16(w, serviceApaas.Role)
	return
}

// UnPack reads the APaaS privileges, room, user, and role.
func (serviceApaas *ServiceApaas) UnPack(r io.Reader) (err error) {
	err = serviceApaas.Service.UnPack(r)
	if err != nil {
		return
	}
	serviceApaas.RoomUuid, err = unPackString(r)
	serviceApaas.UserUuid, err = unPackString(r)
	serviceApaas.Role, err = unPackInt16(r)
	return
}

type AccessToken struct {
	AppCert string
	AppId   string
	Expire  uint32
	IssueTs uint32
	Salt    uint32

	Services    []IService
	signature   []byte
	signingInfo []byte
	parsed      bool
}

// NewAccessToken creates an access token with the current timestamp and a random salt.
func NewAccessToken(appId string, appCert string, expire uint32) (accessToken *AccessToken) {
	issueTs := uint32(time.Now().Unix())
	salt := uint32(getRand(1, 99999999))
	accessToken = &AccessToken{AppCert: appCert, AppId: appId, Expire: expire, IssueTs: issueTs, Salt: salt}
	return
}

// CreateAccessToken creates an empty access token for parsing.
func CreateAccessToken() (accessToken *AccessToken) {
	return NewAccessToken("", "", 900)
}

// AddService adds a service without replacing an existing service of the same type.
func (accessToken *AccessToken) AddService(service IService) {
	accessToken.Services = append(accessToken.Services, service)
}

// GetServices returns all services of the requested type in insertion or token order.
func (accessToken *AccessToken) GetServices(serviceType uint16) []IService {
	services := make([]IService, 0)
	for _, service := range accessToken.Services {
		if service.getServiceType() == serviceType {
			services = append(services, service)
		}
	}

	return services
}

// Build serializes all services into a Token007 token and requires at least one service.
func (accessToken *AccessToken) Build() (res string, err error) {
	recoverException()

	if !isUuid(accessToken.AppId) || !isUuid(accessToken.AppCert) {
		return "", errors.New("check appId or appCertificate")
	}
	if len(accessToken.Services) == 0 {
		return "", errors.New("no service added")
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
	services := accessToken.servicesForPacking()
	if err = packUint16(buf, uint16(len(services))); err != nil {
		return
	}

	// Sign
	var sign []byte
	sign, err = accessToken.getSign(accessToken.AppCert)

	if err != nil {
		return
	}

	// Pack services in stable service type order.
	for _, service := range services {
		err = service.Pack(buf)
		if err != nil {
			return
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

// Parse parses known services and keeps the original signing bytes for independent verification.
func (accessToken *AccessToken) Parse(token string) (res bool, err error) {
	recoverException()

	// Clear the previous token state so a failed parse cannot reuse its signature or services.
	accessToken.AppId = ""
	accessToken.IssueTs = 0
	accessToken.Expire = 0
	accessToken.Salt = 0
	accessToken.Services = nil
	accessToken.signature = nil
	accessToken.signingInfo = nil
	accessToken.parsed = false

	if len(token) < VersionLength {
		return false, errors.New("invalid token length")
	}

	version := token[:VersionLength]
	if version != getVersion() {
		return false, errors.New("invalid token version")
	}

	var decodeByte []byte
	if decodeByte, err = base64DecodeStr(token[VersionLength:]); err != nil {
		return
	}
	var rawTokenBuffer []byte
	if rawTokenBuffer, err = decompressZlibWithError(decodeByte); err != nil {
		return false, err
	}

	buffer := bytes.NewReader(rawTokenBuffer)
	// signature
	var signature string
	if signature, err = unPackString(buffer); err != nil {
		return false, err
	}
	accessToken.signature = []byte(signature)
	accessToken.signingInfo = append(accessToken.signingInfo[:0], rawTokenBuffer[len(rawTokenBuffer)-buffer.Len():]...)
	accessToken.Services = nil

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
		if service == nil {
			accessToken.parsed = true
			return true, nil
		}
		if err = service.UnPack(buffer); err != nil {
			return
		}
		accessToken.AddService(service)
	}

	accessToken.parsed = true
	return true, nil
}

// VerifySignature verifies the parsed token without rebuilding its service payload.
func (accessToken *AccessToken) VerifySignature(appCertificate string) (bool, error) {
	if !accessToken.parsed || len(accessToken.signature) == 0 || len(accessToken.signingInfo) == 0 {
		return false, errors.New("parse token before verifying signature")
	}
	if !isUuid(accessToken.AppId) || !isUuid(appCertificate) {
		return false, errors.New("check appId or appCertificate")
	}

	sign, err := accessToken.getSign(appCertificate)
	if err != nil {
		return false, err
	}

	hSign := hmac.New(sha256.New, sign)
	if _, err = hSign.Write(accessToken.signingInfo); err != nil {
		return false, err
	}

	return hmac.Equal(accessToken.signature, hSign.Sum(nil)), nil
}

// servicesForPacking returns services in stable type order while preserving duplicate insertion order.
func (accessToken *AccessToken) servicesForPacking() []IService {
	services := append([]IService(nil), accessToken.Services...)

	sort.SliceStable(services, func(i, j int) bool {
		return services[i].getServiceType() < services[j].getServiceType()
	})

	return services
}

// getSign derives the signing key from the token timestamp, salt, and supplied certificate.
func (accessToken *AccessToken) getSign(appCertificate string) (sign []byte, err error) {
	// IssueTs
	bufIssueTs := new(bytes.Buffer)
	err = packUint32(bufIssueTs, accessToken.IssueTs)
	if err != nil {
		return
	}
	hIssueTs := hmac.New(sha256.New, bufIssueTs.Bytes())
	hIssueTs.Write([]byte(appCertificate))

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

// newService creates a parser for a known service type and returns nil for unknown types.
func (accessToken *AccessToken) newService(serviceType uint16) (service IService) {
	switch serviceType {
	case ServiceTypeRtc:
		service = NewServiceRtc("", "")
	case ServiceTypeRtm:
		service = NewServiceRtm("")
	case ServiceTypeStreaming:
		service = NewServiceStreaming("", "")
	case ServiceTypeFpa:
		service = NewServiceFpa()
	case ServiceTypeChat:
		service = NewServiceChat("")
	case ServiceTypeFCdn:
		service = NewServiceFCdn("", "")
	case ServiceTypeApaas:
		service = NewServiceApaas("", "", -1)
	case ServiceTypeRtm2:
		service = NewServiceRtm2("", nil)
	default:
		service = nil
	}
	return
}

// GetUidStr converts a numeric user ID to its token representation.
func GetUidStr(uid uint32) string {
	if uid == 0 {
		return ""
	}
	return fmt.Sprintf("%d", uid)
}

// getVersion returns the AccessToken2 version prefix.
func getVersion() string {
	return Version
}

// isUuid reports whether a string is a 32-character hexadecimal identifier.
func isUuid(s string) (res bool) {
	if len(s) != 32 {
		return
	}
	if _, err := hex.DecodeString(s); err != nil {
		return
	}
	return true
}
