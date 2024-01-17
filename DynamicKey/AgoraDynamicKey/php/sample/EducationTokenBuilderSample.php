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

echo "App Id: " . $appId . PHP_EOL;
echo "App Certificate: " . $appCertificate . PHP_EOL;
if ($appId == "" || $appCertificate == "") {
    echo "Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE" . PHP_EOL;
    exit;
}

$token = EducationTokenBuilder::buildRoomUserToken($appId, $appCertificate, $roomUuid, $userUuid, $role, $expire);
echo 'Education room user token: ' . $token . PHP_EOL;

$token = EducationTokenBuilder::buildUserToken($appId, $appCertificate, $userUuid, $expire);
echo 'Education user token: ' . $token . PHP_EOL;

$token = EducationTokenBuilder::buildAppToken($appId, $appCertificate, $expire);
echo 'Education app token: ' . $token . PHP_EOL;
