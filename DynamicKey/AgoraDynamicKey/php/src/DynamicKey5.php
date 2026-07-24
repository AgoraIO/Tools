<?php
$version = "005";
$NO_UPLOAD = "0";
$AUDIO_VIDEO_UPLOAD = "3";

// InChannelPermissionKey
$ALLOW_UPLOAD_IN_CHANNEL = 1;

// Service Type
$MEDIA_CHANNEL_SERVICE = 1;
$RECORDING_SERVICE = 2;
$PUBLIC_SHARING_SERVICE = 3;
$IN_CHANNEL_PERMISSION = 4;

    /**
     * Generate a version 005 recording key.
     */
    function generateRecordingKey($appID, $appCertificate, $channelName, $ts, $randomInt, $uid, $expiredTs)
    {
        return generateDynamicKey($appID, $appCertificate, $channelName, $ts, $randomInt, $uid, $expiredTs, $GLOBALS["RECORDING_SERVICE"], array());
    }

    /**
     * Generate a version 005 media channel key.
     */
    function generateMediaChannelKey($appID, $appCertificate, $channelName, $ts, $randomInt, $uid, $expiredTs)
    {
        return generateDynamicKey($appID, $appCertificate, $channelName, $ts, $randomInt, $uid, $expiredTs, $GLOBALS["MEDIA_CHANNEL_SERVICE"], array());
    }

    /**
     * Generate a version 005 in-channel permission key.
     */
    function generateInChannelPermissionKey($appID, $appCertificate, $channelName, $ts, $randomInt, $uid, $expiredTs, $permission)
    {
        $extra[$GLOBALS["ALLOW_UPLOAD_IN_CHANNEL"]] = $permission;
        return generateDynamicKey($appID, $appCertificate, $channelName, $ts, $randomInt, $uid, $expiredTs, $GLOBALS["IN_CHANNEL_PERMISSION"], $extra);
    }

    /**
     * Generate a version 005 dynamic key for a service type.
     */
    function generateDynamicKey($appID, $appCertificate, $channelName, $ts, $randomInt, $uid, $expiredTs, $serviceType, $extra)
    {
        $signature = generateSignature($serviceType, $appID, $appCertificate, $channelName, $uid, $ts, $randomInt, $expiredTs, $extra);
        $content = packContent($serviceType, $signature, hex2bin($appID), $ts, $randomInt, $expiredTs, $extra);
        // echo bin2hex($content);
        return $GLOBALS["version"] . base64_encode($content);
    }

    /**
     * Generate the HMAC-SHA1 signature for a version 005 key.
     */
    function generateSignature($serviceType, $appID, $appCertificate, $channelName, $uid, $ts, $salt, $expiredTs, $extra)
    {
        $rawAppID = hex2bin($appID);
        $rawAppCertificate = hex2bin($appCertificate);
        
        $buffer = pack("S", $serviceType);
        $buffer .= pack("S", strlen($rawAppID)) . $rawAppID;
        $buffer .= pack("I", $ts);
        $buffer .= pack("I", $salt);
        $buffer .= pack("S", strlen($channelName)) . $channelName;
        $buffer .= pack("I", $uid);
        $buffer .= pack("I", $expiredTs);

        $buffer .= pack("S", count($extra));
        foreach ($extra as $key => $value) {
            $buffer .= pack("S", $key);
            $buffer .= pack("S", strlen($value)) . $value;
        } 

        return strtoupper(hash_hmac('sha1', $buffer, $rawAppCertificate));
    }

    /**
     * Pack a string with an unsigned 16-bit length prefix.
     */
    function packString($value)
    {
        return pack("S", strlen($value)) . $value;
    }

    /**
     * Serialize a complete version 005 key payload.
     */
    function packContent($serviceType, $signature, $appID, $ts, $salt, $expiredTs, $extra)
    {
        $buffer = pack("S", $serviceType);
        $buffer .= packString($signature);
        $buffer .= packString($appID);
        $buffer .= pack("I", $ts);
        $buffer .= pack("I", $salt);
        $buffer .= pack("I", $expiredTs);

        $buffer .= pack("S", count($extra));
        foreach ($extra as $key => $value) {
            $buffer .= pack("S", $key);
            $buffer .= packString($value);
        } 

        return $buffer;
    }

?>
