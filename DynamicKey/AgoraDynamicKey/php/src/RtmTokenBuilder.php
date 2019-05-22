<?php

require "AccessToken.php";

class RtmTokenBuilder
{
    public $token;
    public function __construct($appID, $appCertificate, $account){
        $this->token = new AccessToken();
        $this->token->appID = $appID;
        $this->token->appCertificate = $appCertificate;
        $this->token->channelName = $account;
        $this->token->setUid(0);
    }
    public static function initWithToken($token, $appCertificate, $channel, $uid){
        $this->token = AccessToken::initWithToken($token, $appCertificate, $channel, $uid);
    }
    public function initPrivilege($role){
        $p = self::RolePrivileges[$role];
        foreach($p as $key => $value){
            $this->setPrivilege($key, $value);
        }
    }
    public function setPrivilege($privilege, $expireTimestamp){
        $this->token->addPrivilege($privilege, $expireTimestamp);
    }
    public function removePrivilege($privilege){
        unset($this->token->message->privileges[$privilege]);
    }
    public function buildToken(){
        return $this->token->build();
    }
}


?>