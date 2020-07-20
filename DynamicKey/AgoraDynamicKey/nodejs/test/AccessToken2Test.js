/**
 * run this test with command:
 * nodeunit AccessTokenTest.js
 * see https://github.com/caolan/nodeunit
 */
 const {AccessToken2, ServiceRtc} = require('../src/AccessToken2')
 
 var appID = "970CA35de60c44645bbae8a215061b33";
 var appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
 var channel = "7d72365eb983485397e3e3f9d460bdda";
 var uid = 2882341273;
 var ts = 1111111;
 var expire = 600;
 
 exports.AccessToken_Test = function (test) {
   var expected = "007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj";
 
   var token = new AccessToken2(appID, appCertificate, ts, expire);
   let rtc_service = new ServiceRtc(channel, uid)
   rtc_service.add_privilege(ServiceRtc.kPrivilegeJoinChannel, expire)
   token.add_service(rtc_service)
 
   var actual = token.build();
   test.equal(expected, actual);
   test.done();
 };
 
 // test uid = 0
//  exports.AccessToken_Test2 = function (test) {
//    var expected = "006970CA35de60c44645bbae8a215061b33IACw1o7htY6ISdNRtku3p9tjTPi0jCKf9t49UHJhzCmL6bdIfRAAAAAAEAABAAAAR/QQAAEAAQCvKDdW";
 
//    var uid_zero = 0;
//    var key = new AccessToken.AccessToken(appID, appCertificate, channel, uid_zero);
//    key.salt = salt;
//    key.ts = ts;
//    key.messages[Priviledges.kJoinChannel] = expireTimestamp;
 
//    var actual = key.build();
//    test.equal(expected, actual);
//    test.done();
//  };