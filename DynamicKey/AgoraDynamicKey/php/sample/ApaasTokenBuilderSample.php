<?php
include("../src/ApaasTokenBuilder.php");

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

$token = ApaasTokenBuilder::buildRoomUserToken($appId, $appCertificate, $roomUuid, $userUuid, $role, $expire);
echo 'Apaas room user token: ' . $token . PHP_EOL;

$token = ApaasTokenBuilder::buildUserToken($appId, $appCertificate, $userUuid, $expire);
echo 'Apaas user token: ' . $token . PHP_EOL;

$token = ApaasTokenBuilder::buildAppToken($appId, $appCertificate, $expire);
echo 'Apaas app token: ' . $token . PHP_EOL;
