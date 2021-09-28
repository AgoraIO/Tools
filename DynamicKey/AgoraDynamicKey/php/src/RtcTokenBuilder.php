<?php

require_once "AccessToken.php";

class RtcTokenBuilder
{
    const RoleAttendee = 0;
    const RolePublisher = 1;
    const RoleSubscriber = 2;
    const RoleAdmin = 101;

    # appID: The App ID issued to you by Agora. Apply for a new App ID from 
    #        Agora Dashboard if it is missing from your kit. See Get an App ID.
    # appCertificate:	Certificate of the application that you registered in 
    #                  the Agora Dashboard. See Get an App Certificate.
    # channelName:Unique channel name for the AgoraRTC session in the string format
    # uid: User ID. A 32-bit unsigned integer with a value ranging from 
    #      1 to (232-1). optionalUid must be unique.
    # role: Role_Publisher = 1: A broadcaster (host) in a live-broadcast profile.
    #       Role_Subscriber = 2: (Default) A audience in a live-broadcast profile.
    # privilegeExpireTs: represented by the number of seconds elapsed since 
    #                    1/1/1970. If, for example, you want to access the
    #                    Agora Service within 10 minutes after the token is 
    #                    generated, set expireTimestamp as the current 
    #                    timestamp + 600 (seconds)./
    # isConnectMicrophone Whether to connect the microphone 1=yes 0=no
    public static function buildTokenWithUid($appID, $appCertificate, $channelName, $uid, $role, $privilegeExpireTs, $isConnectMicrophone = 0)
    {
        return RtcTokenBuilder::buildTokenWithUserAccount($appID, $appCertificate, $channelName, $uid, $role, $privilegeExpireTs, $isConnectMicrophone);
    }

    # appID: The App ID issued to you by Agora. Apply for a new App ID from 
    #        Agora Dashboard if it is missing from your kit. See Get an App ID.
    # appCertificate:	Certificate of the application that you registered in 
    #                  the Agora Dashboard. See Get an App Certificate.
    # channelName:Unique channel name for the AgoraRTC session in the string format
    # userAccount: The user account. 
    # role: Role_Publisher = 1: A broadcaster (host) in a live-broadcast profile.
    #       Role_Subscriber = 2: (Default) A audience in a live-broadcast profile.
    # privilegeExpireTs: represented by the number of seconds elapsed since 
    #                    1/1/1970. If, for example, you want to access the
    #                    Agora Service within 10 minutes after the token is 
    #                    generated, set expireTimestamp as the current 
    public static function buildTokenWithUserAccount($appID, $appCertificate, $channelName, $userAccount, $role, $privilegeExpireTs, $isConnectMicrophone = 0)
    {
        $token = AccessToken::init($appID, $appCertificate, $channelName, $userAccount);

        /**
         * Lianmai authentication requires the following subdivision permissions
         * Whether to connect the microphone
         * Documentation：https://docs.agora.io/cn/Video/token_server?platform=Android
         * Documentation：https://docs.agora.io/cn/Interactive%20Broadcast/faq/token_cohost
         */
        if ($isConnectMicrophone == 1){
            $Privileges = AccessToken::Privileges;
            $token->addPrivilege($Privileges["kJoinChannel"], $privilegeExpireTs);
            if (($role == RtcTokenBuilder::RoleAttendee) ||
                ($role == RtcTokenBuilder::RolePublisher) ||
                ($role == RtcTokenBuilder::RoleAdmin)) {
                $token->addPrivilege($Privileges["kPublishVideoStream"], $privilegeExpireTs);
                $token->addPrivilege($Privileges["kPublishAudioStream"], $privilegeExpireTs);
                $token->addPrivilege($Privileges["kPublishDataStream"], $privilegeExpireTs);
            }
        }
        return $token->build();
    }
}


?>