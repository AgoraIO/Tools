<?php
include("../src/RtmTokenBuilder.php");

$appID = "970CA35de60c44645bbae8a215061b33";
$appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
$account = "testaccount";

$builder = new RtmTokenBuilder($appID, $appCertificate, $account);
$builder->setPrivilege(AccessToken::Privileges["kRtmLogin"], 0);
echo $builder->buildToken();

?>
