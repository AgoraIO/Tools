<?php
require_once("../src/FpaTokenBuilder.php");

$appId = "970CA35de60c44645bbae8a215061b33";
$appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";

$token = FpaTokenBuilder::buildToken($appId, $appCertificate);
echo 'Token with FPA service: ' . $token . PHP_EOL;
