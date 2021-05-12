<?php
include("../src/AccessToken2.php");

$appID = "970CA35de60c44645bbae8a215061b33";
$appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
$channelName = "7d72365eb983485397e3e3f9d460bdda";
$uid = 2882341273;
$uidStr = "2882341273";
$expireTimeInSeconds = 600;

// $token = RtmTokenBuilder::buildToken($appID, $appCertificate, $user, $role, $privilegeExpiredTs);
$accessToken = new AccessToken2($appID, $appCertificate, $expireTimeInSeconds);

// grant rtc privileges
$serviceRtc = new ServiceRtc($channelName, $uid);
$serviceRtc->addPrivilege($serviceRtc::PRIVILEGE_JOIN_CHANNEL, $expireTimeInSeconds);
$accessToken->addService($serviceRtc);

// grant rtm privileges
$serviceRtm = new ServiceRtm($uidStr);
$serviceRtm->addPrivilege($serviceRtm::PRIVILEGE_JOIN_LOGIN, $expireTimeInSeconds);
$accessToken->addService($serviceRtm);

// grant chat privileges
$serviceChat = new ServiceChat($uidStr);
$serviceChat->addPrivilege($serviceChat::PRIVILEGE_USER, $expireTimeInSeconds);
$accessToken->addService($serviceChat);

$token = $accessToken->build();
echo 'Token with RTC, RTM, CHAT privileges: ' . $token . PHP_EOL;

?>
