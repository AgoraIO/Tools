<?php
require "../src/AccessToken.php";

$appID = '970CA35de60c44645bbae8a215061b33';
$appCertificate = '5CFd2fd1755d40ecb72977518be15d3b';
$channelName = "7d72365eb983485397e3e3f9d460bdda";
$uid = 2882341273;
$expireTimestamp = 0;


$builder = new AccessToken();
$builder->init($appID, $appCertificate, $channelName, $uid);
$builder->addPrivilege(AccessToken::Privileges["kJoinChannel"], $expireTimestamp);
echo $builder->build();

?>
