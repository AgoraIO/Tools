<?php

require_once "AccessToken.php";

class RtmTokenBuilder
{
    const RoleRtmUser = 1;
    # appID: The App ID issued to you by Agora. Apply for a new App ID from 
    #        Agora Dashboard if it is missing from your kit. See Get an App ID.
    # appCertificate:	Certificate of the application that you registered in 
    #                  the Agora Dashboard. See Get an App Certificate.
    # channelName:Unique channel name for the AgoraRTC session in the string format
    # userAccount: The user account. 
    # role: Role_Rtm_User = 1
    # privilegeExpireTs: represented by the number of seconds elapsed since 
    #                    1/1/1970. If, for example, you want to access the
    #                    Agora Service within 10 minutes after the token is 
    #                    generated, set expireTimestamp as the current 
    #                    timestamp + 600 (seconds)./
    public static function buildToken($appID, $appCertificate, $userAccount, $role, $privilegeExpireTs){
        $token = AccessToken::init($appID, $appCertificate, $userAccount, "");
        $Privileges = AccessToken::Privileges;
        $token->addPrivilege($Privileges["kRtmLogin"], $privilegeExpireTs);
        return $token->build();
    }
}


?>