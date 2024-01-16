<?php
include("../src/EducationTokenBuilder.php");

// Need to set environment variable AGORA_APP_ID
$appId = getenv("AGORA_APP_ID");
// Need to set environment variable AGORA_APP_CERTIFICATE
$appCertificate = getenv("AGORA_APP_CERTIFICATE");

$expire = 600;
$roomUuid = "123";
$userUuid = "2882341273";
$role = 1;

$token = EducationTokenBuilder::buildRoomUserToken($appId, $appCertificate, $roomUuid, $userUuid, $role, $expire);
echo 'Education room user token: ' . $token . PHP_EOL;

$token = EducationTokenBuilder::buildUserToken($appId, $appCertificate, $userUuid, $expire);
echo 'Education user token: ' . $token . PHP_EOL;

$token = EducationTokenBuilder::buildAppToken($appId, $appCertificate, $expire);
echo 'Education app token: ' . $token . PHP_EOL;
