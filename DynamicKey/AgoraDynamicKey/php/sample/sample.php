<?php

    include '../src/DynamicKey4.php';

    $appID = '970ca35de60c44645bbae8a215061b33';
    $appCertificate = '5cfd2fd1755d40ecb72977518be15d3b';
    $channelName = "7d72365eb983485397e3e3f9d460bdda";
    $ts = (string)time();
    $randomInt = rand(100000000, 999999999);
    $uid = 2882341273;
    $expiredTs = 0;

    $recordingKey = generateRecordingKey($appID, $appCertificate, $channelName, $ts, $randomInt, $uid, $expiredTs);
    echo('recordingKey : ' . $recordingKey . '<br /><br />');

	$mediaChannelKey = generateMediaChannelKey($appID, $appCertificate, $channelName, $ts, $randomInt, $uid, $expiredTs);
    echo('mediaChannelKey : ' . $mediaChannelKey);

?>
