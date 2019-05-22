<?php
include "../src/RtmTokenBuilder.php";
include "TestTool.php";

$appID = "970CA35de60c44645bbae8a215061b33";
$appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
$account = "test_user";
$ts = 1111111;
$salt = 1;
$expiredTs = 1446455471;


$expected = "006970CA35de60c44645bbae8a215061b33IAAsR0qgiCxv0vrpRcpkz5BrbfEWCBZ6kvR6t7qG/wJIQob86ogAAAAAEAABAAAAR/QQAAEA6AOvKDdW";
$builder = new RtmTokenBuilder($appID, $appCertificate, $account);
$builder->setPrivilege(AccessToken::Privileges["kRtmLogin"], $expiredTs);
$builder->token->message->salt = $salt;
$builder->token->message->ts = $ts;
$result = $builder->buildToken();
assertEqual($expected, $result);


$expected = "006970CA35de60c44645bbae8a215061b33IABR8ywaENKv6kia6iUU6P54g017Bi6Ym9sIGdt9f3sLLYb86ogAAAAAEAABAAAAR/QQAAEA6ANkAAAA";
$builder = new RtmTokenBuilder($appID, $appCertificate, $account);
$builder->setPrivilege(AccessToken::Privileges["kRtmLogin"], 100);
$builder->token->message->salt = $salt;
$builder->token->message->ts = $ts;
$result = $builder->buildToken();
assertEqual($expected, $result);

?>