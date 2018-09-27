<?php

$SDK_VERSION = "1";

function getToken($appid, $appcertificate, $account, $validTimeInSeconds){
    global $SDK_VERSION;
    $expiredTime = time() + $validTimeInSeconds;

    $token_items = array();
    array_push($token_items, $SDK_VERSION);
    array_push($token_items, $appid);
    array_push($token_items, $expiredTime);
    array_push($token_items, md5($account.$appid.$appcertificate.$expiredTime));
    return join(":", $token_items);
}

?>