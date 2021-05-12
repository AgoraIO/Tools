<?php

require_once "Util.php";

class Service
{
    public $type;
    public $privileges;

    public function __construct($serviceType)
    {
        $this->type = $serviceType;
    }

    public function addPrivilege($privilege, $expire)
    {
        $this->privileges[$privilege] = $expire;
    }

    public function getServiceType()
    {
        return $this->type;
    }

    public function pack()
    {
        return Util::packUint16($this->type) . Util::packMapUint32($this->privileges);
    }

    public function unpack(&$data)
    {
        $this->privileges = Util::unpackMapUint32($data);
    }
}

class ServiceRtc extends Service
{
    const SERVICE_TYPE = 1;
    const PRIVILEGE_JOIN_CHANNEL = 1;
    const PRIVILEGE_PUBLISH_AUDIO_STREAM = 2;
    const PRIVILEGE_PUBLISH_VIDEO_STREAM = 3;
    const PRIVILEGE_PUBLISH_DATA_STREAM = 4;
    public $channelName;
    public $uid;

    public function __construct($channelName = "", $uid = "")
    {
        parent::__construct(self::SERVICE_TYPE);
        $this->channelName = $channelName;
        $this->uid = $uid;
    }

    public function pack()
    {
        return parent::pack() . Util::packString($this->channelName) . Util::packString($this->uid);
    }

    public function unpack(&$data)
    {
        parent::unpack($data);
        $this->channelName = Util::unpackString($data);
        $this->uid = Util::unpackString($data);
    }
}

class ServiceRtm extends Service
{
    const SERVICE_TYPE = 2;
    const PRIVILEGE_JOIN_LOGIN = 1;
    public $userId;

    public function __construct($userId = "")
    {
        parent::__construct(self::SERVICE_TYPE);
        $this->userId = $userId;
    }

    public function pack()
    {
        return parent::pack() . Util::packString($this->userId);
    }

    public function unpack(&$data)
    {
        parent::unpack($data);
        $this->userId = Util::unpackString($data);
    }
}

class ServiceStreaming extends Service
{
    const SERVICE_TYPE = 3;
    const PRIVILEGE_PUBLISH_MIX_STREAM = 1;
    const PRIVILEGE_PUBLISH_RAW_STREAM = 2;
    public $channelName;
    public $uid;

    public function __construct($channelName = "", $uid = "")
    {
        parent::__construct(self::SERVICE_TYPE);
        $this->channelName = $channelName;
        $this->uid = $uid;
    }

    public function pack()
    {
        return parent::pack() . Util::packString($this->channelName) . Util::packString($this->uid);
    }

    public function unpack(&$data)
    {
        parent::unpack($data);
        $this->channelName = Util::unpackString($data);
        $this->uid = Util::unpackString($data);
    }
}

class ServiceChat extends Service
{
    const SERVICE_TYPE = 5;
    const PRIVILEGE_USER = 1;
    const PRIVILEGE_APP = 2;
    public $userId;

    public function __construct($userId = "")
    {
        parent::__construct(self::SERVICE_TYPE);
        $this->userId = $userId;
    }

    public function pack()
    {
        return parent::pack() . Util::packString($this->userId);
    }

    public function unpack(&$data)
    {
        parent::unpack($data);
        $this->userId = Util::unpackString($data);
    }
}

class AccessToken2
{
    const VERSION = "007";
    const VERSION_LENGTH = 3;
    public $appCert;
    public $appId;
    public $expire;
    public $issueTs;
    public $salt;
    public $services = [];

    public function __construct($appId = "", $appCert = "", $expire = 900)
    {
        $this->appId = $appId;
        $this->appCert = $appCert;
        $this->expire = $expire;
        $this->issueTs = time();
        $this->salt = rand(1, 99999999);
    }

    public function addService($service)
    {
        $this->services[$service->getServiceType()] = $service;
    }

    public function build()
    {
        if (!self::isUUid($this->appId) || !self::isUUid($this->appCert)) {
            return "";
        }

        $signing = $this->getSign();
        $data = Util::packString($this->appId) . Util::packUint32($this->issueTs) . Util::packUint32($this->expire)
            . Util::packUint32($this->salt) . Util::packUint16(count($this->services));

        foreach ($this->services as $key => $service) {
            $data .= $service->pack();
        }

        $signature = hash_hmac("sha256", $data, $signing, true);

        return self::getVersion() . base64_encode(zlib_encode(Util::packString($signature) . $data, ZLIB_ENCODING_DEFLATE));
    }

    public function getSign()
    {
        $hh = hash_hmac("sha256", $this->appCert, Util::packUint32($this->issueTs), true);
        return hash_hmac("sha256", $hh, Util::packUint32($this->salt), true);
    }

    public static function getVersion()
    {
        return self::VERSION;
    }

    public static function isUUid($str)
    {
        if (strlen($str) != 32) {
            return false;
        }
        return ctype_xdigit($str);
    }

    public function parse($token)
    {
        if (substr($token, 0, self::VERSION_LENGTH) != self::getVersion()) {
            return false;
        }

        $data = zlib_decode(base64_decode(substr($token, self::VERSION_LENGTH)));
        $signature = Util::unpackString($data);
        $this->appId = Util::unpackString($data);
        $this->issueTs = Util::unpackUint32($data);
        $this->expire = Util::unpackUint32($data);
        $this->salt = Util::unpackUint32($data);
        $serviceNum = Util::unpackUint16($data);

        $servicesObj = [
            ServiceRtc::SERVICE_TYPE => new ServiceRtc(),
            ServiceRtm::SERVICE_TYPE => new ServiceRtm(),
            ServiceStreaming::SERVICE_TYPE => new ServiceStreaming(),
            ServiceChat::SERVICE_TYPE => new ServiceChat()
        ];
        for ($i = 0; $i < $serviceNum; $i++) {
            $serviceTye = Util::unpackUint16($data);
            $service = $servicesObj[$serviceTye];
            if ($service == null) {
                return false;
            }
            $service->unpack($data);
            $this->services[$serviceTye] = $service;
        }
        return true;
    }
}
