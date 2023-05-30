// Copyright Agora.io. All rights reserved.
// This program can return different tokens, according to different request parameters.
// You can use this program to generate tokens for the following services:
// - Agora RTC
// - Agora RTM
// - Agora FPA
// - Agora Chat
// - Agora Education
// This program is for reference only and is not recommended for direct use in a production environment.
// If you need to use it in a production environment, you need to add a permission verification mechanism.
// For example, you can add a parameter to the request body, and then verify the parameter in the program.
//
// Run server locally
// 1. Fill in the AppId and AppCertificate in the code.
// 2. Run the command "go run server.go".
// 3. Send a POST request to http://localhost:8080/token/generate.
//   For example:
//      curl --location 'http://localhost:8080/token/generate' \
//      --header 'Content-Type: application/json' \
//      --data '{
//          "channelName": "channel_name_test",
//          "uid": "12345678",
//          "tokenExpireTs": 3600,
//          "privilegeExpireTs": 3600,
//          "serviceRtc": {
//              "enable": true,
//              "role": 1
//          },
//          "serviceRtm": {
//              "enable": true
//          }
//      }'
// 4. The response is a token.
//
// Run server in docker
// Run the command "docker run -d -it -p 8080:8080 -e APP_ID=YOUR_APP_ID -e APP_CERTIFICATE=YOUR_APP_CERTIFICATE --name agora-token-service agoracn/token:0.1.2023053011"
// You can also run the service by modifying the docker-compose.yaml file.
// Open the docker-compose.yaml file and set APP_ID and APP_CERTIFICATE.
// Run the command "docker-compose up"

package main

import (
	"log"
	"net/http"
	"os"

	accessTokenBuilder "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/accesstoken2"
	rtcTokenBuilder "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/rtctokenbuilder2"
	"github.com/gin-gonic/gin"
)

// Request parameters
type Request struct {
	// Unique channel name for the AgoraRTC session in the string format
	ChannelName string `json:"channelName,omitempty"`
	// User ID. A 32-bit unsigned integer with a value ranging from 1 to (2^32-1)
	Uid string `json:"uid,omitempty"`
	// Represented by the number of seconds elapsed since now. If, for example,
	// you want to access the Agora Service within 10 minutes after the token is generated,
	// set tokenExpireTs as 600(seconds).
	TokenExpireTs uint32 `json:"tokenExpireTs,omitempty"`
	// Represented by the number of seconds elapsed since now. If, for example,
	// you want to enable your privilege for 10 minutes, set privilegeExpireTs as 600(seconds).
	PrivilegeExpireTs uint32                  `json:"privilegeExpireTs,omitempty"`
	ServiceRtc        RequestServiceRtc       `json:"serviceRtc,omitempty"`
	ServiceRtm        RequestServiceRtm       `json:"serviceRtm,omitempty"`
	ServiceFpa        RequestServiceFpa       `json:"serviceFpa,omitempty"`
	ServiceChat       RequestServiceChat      `json:"serviceChat,omitempty"`
	ServiceEducation  RequestServiceEducation `json:"serviceEducation,omitempty"`
}

type RequestServiceRtc struct {
	Enable bool `json:"enable,omitempty"`
	// RolePublisher: A broadcaster/host in a live-broadcast profile.
	// RoleSubscriber: An audience(default) in a live-broadcast profile.
	Role rtcTokenBuilder.Role `json:"role,omitempty"`
}

type RequestServiceRtm struct {
	Enable bool `json:"enable,omitempty"`
}

type RequestServiceFpa struct {
	Enable bool `json:"enable,omitempty"`
}

type RequestServiceChat struct {
	// Refer to BuildChatUserToken of src/chatTokenBuilder/chatTokenBuilder.go
	EnableUser bool `json:"enableUser,omitempty"`
	// Refer to BuildChatAppToken of src/chatTokenBuilder/chatTokenBuilder.go
	EnableApp bool `json:"enableApp,omitempty"`
	// The user's id, must be unique.
	UserUuid string `json:"userUuid,omitempty"`
}

type RequestServiceEducation struct {
	// Refer to BuildUserToken of src/educationtokenbuilder/educationtokenbuilder.go
	EnableUser bool `json:"enableUser,omitempty"`
	// Refer to BuildAppToken of src/educationtokenbuilder/educationtokenbuilder.go
	EnableApp bool `json:"enableApp,omitempty"`
	// The user's id, must be unique.
	UserUuid string `json:"userUuid,omitempty"`
}

// Return response
type Response struct {
	Token string `json:"token"`
}

const (
	// Server port
	ServerPort = ":8080"
	// Server url
	Url = "/token/generate"

	// Info code
	CodeOk        = 0
	CodeOkMessage = "Success"
	// Error code
	CodeErrorParams   = -1
	CodeErrorGenerate = -2
)

var (
	// Notice
	// Fill the AppId and AppCertificate generated in the Agora Console here.
	AppId          = ""
	AppCertificate = ""
)

// Init
// Check appId and appCertificate
func init() {
	if appId := os.Getenv("APP_ID"); appId != "" {
		AppId = appId
	}
	if appCertificate := os.Getenv("APP_CERTIFICATE"); appCertificate != "" {
		AppCertificate = appCertificate
	}

	if AppId == "" || AppCertificate == "" {
		log.Printf("check appId or appCertificate")
		os.Exit(1)
	}
}

// Generate token
func generateToken(request *Request) (token string, err error) {
	accessToken := accessTokenBuilder.NewAccessToken(AppId, AppCertificate, request.TokenExpireTs)

	// refer to src/rtctokenbuilder2/rtctokenbuilder.go
	if request.ServiceRtc.Enable {
		serviceRtc := accessTokenBuilder.NewServiceRtc(request.ChannelName, request.Uid)
		serviceRtc.AddPrivilege(accessTokenBuilder.PrivilegeJoinChannel, request.PrivilegeExpireTs)
		if request.ServiceRtc.Role == rtcTokenBuilder.RolePublisher {
			serviceRtc.AddPrivilege(accessTokenBuilder.PrivilegePublishAudioStream, request.PrivilegeExpireTs)
			serviceRtc.AddPrivilege(accessTokenBuilder.PrivilegePublishVideoStream, request.PrivilegeExpireTs)
			serviceRtc.AddPrivilege(accessTokenBuilder.PrivilegePublishDataStream, request.PrivilegeExpireTs)
		}
		accessToken.AddService(serviceRtc)
	}

	// refer to src/rtmtokenbuilder2/rtmtokenbuilder.go
	if request.ServiceRtm.Enable {
		serviceRtm := accessTokenBuilder.NewServiceRtm(request.Uid)
		serviceRtm.AddPrivilege(accessTokenBuilder.PrivilegeLogin, request.TokenExpireTs)
		accessToken.AddService(serviceRtm)
	}

	// refer to src/fpatokenbuilder/fpatokenbuilder.go
	if request.ServiceFpa.Enable {
		serviceFpa := accessTokenBuilder.NewServiceFpa()
		serviceFpa.AddPrivilege(accessTokenBuilder.PrivilegeLogin, 0)
		accessToken.AddService(serviceFpa)
	}

	// refer to src/chatTokenBuilder/chatTokenBuilder.go
	if request.ServiceChat.EnableUser {
		serviceChatUser := accessTokenBuilder.NewServiceChat(request.ServiceChat.UserUuid)
		serviceChatUser.AddPrivilege(accessTokenBuilder.PrivilegeChatUser, request.TokenExpireTs)
		accessToken.AddService(serviceChatUser)
	}

	// refer to src/chatTokenBuilder/chatTokenBuilder.go
	if request.ServiceChat.EnableApp {
		serviceChatApp := accessTokenBuilder.NewServiceChat("")
		serviceChatApp.AddPrivilege(accessTokenBuilder.PrivilegeChatApp, request.TokenExpireTs)
		accessToken.AddService(serviceChatApp)
	}

	// refer to src/educationtokenbuilder/educationtokenbuilder.go
	if request.ServiceEducation.EnableUser {
		serviceEducationUser := accessTokenBuilder.NewServiceEducation("", request.ServiceEducation.UserUuid, -1)
		serviceEducationUser.AddPrivilege(accessTokenBuilder.PrivilegeEducationUser, request.TokenExpireTs)
		accessToken.AddService(serviceEducationUser)
	}

	// refer to src/educationtokenbuilder/educationtokenbuilder.go
	if request.ServiceEducation.EnableApp {
		serviceEducationApp := accessTokenBuilder.NewServiceEducation("", "", -1)
		serviceEducationApp.AddPrivilege(accessTokenBuilder.PrivilegeEducationApp, request.TokenExpireTs)
		accessToken.AddService(serviceEducationApp)
	}

	return accessToken.Build()
}

// Output response
func output(c *gin.Context, request *Request, httpStatus int, code int, message string, data interface{}) {
	log.Printf("request:%+v, httpStatus:%d, code:%d, message:%s", request, httpStatus, code, message)
	c.JSON(httpStatus, gin.H{"code": code, "message": message, "data": data})
}

// Start server
func main() {
	r := gin.Default()
	r.POST(Url, func(c *gin.Context) {
		// Get params
		var request Request
		if err := c.BindJSON(&request); err != nil {
			output(c, &request, http.StatusBadRequest, CodeErrorParams, err.Error(), "")
			return
		}

		// Generate token
		token, err := generateToken(&request)
		if err != nil {
			output(c, &request, http.StatusBadRequest, CodeErrorGenerate, err.Error(), "")
			return
		}

		// Return response
		response := &Response{Token: token}
		output(c, &request, http.StatusOK, CodeOk, CodeOkMessage, response)
	})

	log.Printf("start server, appId:%s, serverPort:%s, url:%s", AppId, ServerPort, Url)
	// Start server
	r.Run(ServerPort)
}
