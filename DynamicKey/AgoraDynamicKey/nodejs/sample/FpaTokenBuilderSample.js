const FpaTokenBuilder = require('../src/FpaTokenBuilder').FpaTokenBuilder

const appID = '970CA35de60c44645bbae8a215061b33'
const appCertificate = '5CFd2fd1755d40ecb72977518be15d3b'

let token = FpaTokenBuilder.buildToken(appID, appCertificate)
console.log("Token with FPA service: " + token)
