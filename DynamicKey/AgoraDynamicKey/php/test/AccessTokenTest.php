<?php
include "../src/RtcTokenBuilder.php";
include "../src/RtmTokenBuilder.php";
include "TestTool.php";

$appID = "970CA35de60c44645bbae8a215061b33";
$appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
$channelName = "7d72365eb983485397e3e3f9d460bdda";
$ts = 1111111;
$salt = 1;
$uid = "2882341273";
$expiredTs = 1446455471;


$expected = "006970CA35de60c44645bbae8a215061b33IACV0fZUBw+72cVoL9eyGGh3Q6Poi8bgjwVLnyKSJyOXR7dIfRBXoFHlEAABAAAAR/QQAAEAAQCvKDdW";
$builder = AccessToken::init($appID, $appCertificate, $channelName, $uid);
$builder->message->salt = $salt;
$builder->message->ts = $ts;
$builder->addPrivilege(AccessToken::Privileges["kJoinChannel"], $expiredTs);
$result = $builder->build();

assertEqual($expected, $result);
$builder2 = AccessToken::initWithToken($expected, $appCertificate, $channelName, $uid);
$result2 = $builder2->build();
assertEqual($expected, $result2);


//test 2 uid 0 case

$appID = "970CA35de60c44645bbae8a215061b33";
$appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
$channelName = "7d72365eb983485397e3e3f9d460bdda";
$ts = 1111111;
$salt = 1;
$uid = "0";
$expiredTs = 1446455471;


$expected = "006970CA35de60c44645bbae8a215061b33IABNRUO/126HmzFc+J8lQFfnkssUdUXqiePeE2WNZ7lyubdIfRAh39v0EAABAAAAR/QQAAEAAQCvKDdW";
$builder = AccessToken::init($appID, $appCertificate, $channelName, $uid);
$builder->message->salt = $salt;
$builder->message->ts = $ts;
$builder->addPrivilege(AccessToken::Privileges["kJoinChannel"], $expiredTs);
$result = $builder->build();

assertEqual($expected, $result);
$builder2 = AccessToken::initWithToken($expected, $appCertificate, $channelName, $uid);
$result2 = $builder2->build();
assertEqual($expected, $result2);


//test 2 uid 0 number case

$appID = "970CA35de60c44645bbae8a215061b33";
$appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
$channelName = "7d72365eb983485397e3e3f9d460bdda";
$ts = 1111111;
$salt = 1;
$uid = 0;
$expiredTs = 1446455471;


$expected = "006970CA35de60c44645bbae8a215061b33IACw1o7htY6ISdNRtku3p9tjTPi0jCKf9t49UHJhzCmL6bdIfRAAAAAAEAABAAAAR/QQAAEAAQCvKDdW";
$builder = AccessToken::init($appID, $appCertificate, $channelName, $uid);
$builder->message->salt = $salt;
$builder->message->ts = $ts;
$builder->addPrivilege(AccessToken::Privileges["kJoinChannel"], $expiredTs);
$result = $builder->build();

assertEqual($expected, $result);
$builder2 = AccessToken::initWithToken($expected, $appCertificate, $channelName, $uid);
$result2 = $builder2->build();
assertEqual($expected, $result2);



$appID = "3d76392019ca47599548a67ad27c9699";
$appCertificate = "386668c56db0499791d32264810c2a29";
$channelName = "7d72365eb983485397e3e3f9d460bdda";
$uid = 2882341273;


$token = RtcTokenBuilder::buildTokenWithUid($appID, $appCertificate, $channelName, $uid, RtcTokenBuilder::RoleAttendee, $expiredTs);
$parser = AccessToken::initWithToken($token, $appCertificate, $channelName, $uid);
$privilegeKey = AccessToken::Privileges["kJoinChannel"];
assertEqual($parser->message->privileges[$privilegeKey], $expiredTs);

$userAccount = "test_user";

$token = RtmTokenBuilder::buildToken($appID, $appCertificate, $userAccount, RtmTokenBuilder::RoleRtmUser, $expiredTs);
$parser = AccessToken::initWithToken($token, $appCertificate, $channelName, $userAccount);
$privilegeKey = AccessToken::Privileges["kRtmLogin"];
assertEqual($parser->message->privileges[$privilegeKey], $expiredTs);

$appID = "";
//invalid values
$expected = "006970CA35de60c44645bbae8a215061b33IACw1o7htY6ISdNRtku3p9tjTPi0jCKf9t49UHJhzCmL6bdIfRAAAAAAEAABAAAAR/QQAAEAAQCvKDdW";
$builder = AccessToken::init($appID, $appCertificate, $channelName, $uid);
assertEqual($builder, NULL);



?>