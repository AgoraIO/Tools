package fpatokenbuilder

import (
    accesstoken "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/accesstoken2"
)

// Build the FPA token.
//
// appId:           The App ID issued to you by Agora. Apply for a new App ID from
//                  Agora Dashboard if it is missing from your kit. See Get an App ID.
// appCertificate:  Certificate of the application that you registered in
//                  the Agora Dashboard. See Get an App Certificate.
// return The FPA token.
func BuildToken(appId string, appCertificate string) (string, error) {
    token := accesstoken.NewAccessToken(appId, appCertificate, 24 * 3600)

    serviceFpa := accesstoken.NewServiceFpa()
    serviceFpa.AddPrivilege(accesstoken.PrivilegeLogin, 0)
    token.AddService(serviceFpa)

    return token.Build()
}
