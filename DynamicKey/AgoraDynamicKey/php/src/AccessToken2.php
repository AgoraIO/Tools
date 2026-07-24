<?php

require_once "Util.php";

/**
 * Represent the common service type and privilege payload.
 */
class Service
{
    public $type;
    public $privileges;

    /**
     * Create a service with the specified numeric type.
     */
    public function __construct($serviceType)
    {
        $this->type = $serviceType;
    }

    /**
     * Add or update a privilege expiration timestamp.
     */
    public function addPrivilege($privilege, $expire)
    {
        $this->privileges[$privilege] = $expire;
    }

    /**
     * Return the numeric service type.
     */
    public function getServiceType()
    {
        return $this->type;
    }

    /**
     * Serialize the service type and privileges.
     */
    public function pack()
    {
        return Util::packUint16($this->type) . Util::packMapUint32($this->privileges);
    }

    /**
     * Deserialize service privileges from the token payload.
     */
    public function unpack(&$data)
    {
        $this->privileges = Util::unpackMapUint32($data);
    }
}

/**
 * Represent RTC channel and user privileges.
 */
class ServiceRtc extends Service
{
    const SERVICE_TYPE = 1;
    const PRIVILEGE_JOIN_CHANNEL = 1;
    const PRIVILEGE_PUBLISH_AUDIO_STREAM = 2;
    const PRIVILEGE_PUBLISH_VIDEO_STREAM = 3;
    const PRIVILEGE_PUBLISH_DATA_STREAM = 4;
    public $channelName;
    public $uid;

    /**
     * Create an RTC service for a channel and user.
     */
    public function __construct($channelName = "", $uid = "")
    {
        parent::__construct(self::SERVICE_TYPE);
        $this->channelName = $channelName;
        $this->uid = $uid;
    }

    /**
     * Serialize the RTC service payload.
     */
    public function pack()
    {
        return parent::pack() . Util::packString($this->channelName) . Util::packString($this->uid);
    }

    /**
     * Deserialize the RTC service payload.
     */
    public function unpack(&$data)
    {
        parent::unpack($data);
        $this->channelName = Util::unpackString($data);
        $this->uid = Util::unpackString($data);
    }
}

/**
 * Represent RTM user login privileges.
 */
class ServiceRtm extends Service
{
    const SERVICE_TYPE = 2;
    const PRIVILEGE_LOGIN = 1;
    public $userId;

    /**
     * Create an RTM service for a user.
     */
    public function __construct($userId = "")
    {
        parent::__construct(self::SERVICE_TYPE);
        $this->userId = $userId;
    }

    /**
     * Serialize the RTM service payload.
     */
    public function pack()
    {
        return parent::pack() . Util::packString($this->userId);
    }

    /**
     * Deserialize the RTM service payload.
     */
    public function unpack(&$data)
    {
        parent::unpack($data);
        $this->userId = Util::unpackString($data);
    }
}

/**
 * Represent FPA login privileges.
 */
class ServiceFpa extends Service
{
    const SERVICE_TYPE = 4;
    const PRIVILEGE_LOGIN = 1;

    /**
     * Create an FPA service.
     */
    public function __construct()
    {
        parent::__construct(self::SERVICE_TYPE);
    }

    /**
     * Serialize the FPA service payload.
     */
    public function pack()
    {
        return parent::pack();
    }

    /**
     * Deserialize the FPA service payload.
     */
    public function unpack(&$data)
    {
        parent::unpack($data);
    }
}

/**
 * Represent Chat user or application privileges.
 */
class ServiceChat extends Service
{
    const SERVICE_TYPE = 5;
    const PRIVILEGE_USER = 1;
    const PRIVILEGE_APP = 2;
    public $userId;

    /**
     * Create a Chat service for a user or application.
     */
    public function __construct($userId = "")
    {
        parent::__construct(self::SERVICE_TYPE);
        $this->userId = $userId;
    }

    /**
     * Serialize the Chat service payload.
     */
    public function pack()
    {
        return parent::pack() . Util::packString($this->userId);
    }

    /**
     * Deserialize the Chat service payload.
     */
    public function unpack(&$data)
    {
        parent::unpack($data);
        $this->userId = Util::unpackString($data);
    }
}

/**
 * Represent APaaS room, user, and application privileges.
 */
class ServiceApaas extends Service
{
    const SERVICE_TYPE = 7;
    const PRIVILEGE_ROOM_USER = 1;
    const PRIVILEGE_USER = 2;
    const PRIVILEGE_APP = 3;

    public $roomUuid;
    public $userUuid;
    public $role;

    /**
     * Create an APaaS service for a room, user, and role.
     */
    public function __construct($roomUuid = "", $userUuid = "", $role = -1)
    {
        parent::__construct(self::SERVICE_TYPE);
        $this->roomUuid = $roomUuid;
        $this->userUuid = $userUuid;
        $this->role = $role;
    }

    /**
     * Serialize the APaaS service payload.
     */
    public function pack()
    {
        return parent::pack() . Util::packString($this->roomUuid) . Util::packString($this->userUuid) . Util::packInt16($this->role);
    }

    /**
     * Deserialize the APaaS service payload.
     */
    public function unpack(&$data)
    {
        parent::unpack($data);
        $this->roomUuid = Util::unpackString($data);
        $this->userUuid = Util::unpackString($data);
        $this->role = Util::unpackInt16($data);
    }
}

/**
 * Build, parse, and verify Token007 tokens containing one or more services.
 */
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
    private $signature = "";
    private $signingInfo = "";
    private $parsed = false;

    /**
     * Create a token builder or an empty token parser.
     */
    public function __construct($appId = "", $appCert = "", $expire = 900)
    {
        $this->appId = $appId;
        $this->appCert = $appCert;
        $this->expire = $expire;
        $this->issueTs = time();
        $this->salt = rand(1, 99999999);
    }

    /**
     * Add a service without replacing services of the same type.
     */
    public function addService($service)
    {
        $this->services[] = $service;
    }

    /**
     * Return all services of the requested type in insertion or token order.
     */
    public function getServices($serviceType)
    {
        return array_values(array_filter($this->services, function ($service) use ($serviceType) {
            return $service->getServiceType() == $serviceType;
        }));
    }

    /**
     * Build a Token007 token and require at least one service.
     */
    public function build()
    {
        if (!self::isUUid($this->appId) || !self::isUUid($this->appCert) || count($this->services) === 0) {
            return "";
        }

        $signing = $this->getSign();
        $services = $this->servicesForPacking();
        $data = Util::packString($this->appId) . Util::packUint32($this->issueTs) . Util::packUint32($this->expire)
            . Util::packUint32($this->salt) . Util::packUint16(count($services));

        foreach ($services as $service) {
            $data .= $service->pack();
        }

        $signature = hash_hmac("sha256", $data, $signing, true);

        return self::getVersion() . base64_encode(zlib_encode(Util::packString($signature) . $data, ZLIB_ENCODING_DEFLATE));
    }

    /**
     * Derive the signing key with the stored or supplied App Certificate.
     */
    public function getSign($appCertificate = null)
    {
        $certificate = $appCertificate === null ? $this->appCert : $appCertificate;
        $hh = hash_hmac("sha256", $certificate, Util::packUint32($this->issueTs), true);
        return hash_hmac("sha256", $hh, Util::packUint32($this->salt), true);
    }

    /**
     * Return the Token007 version prefix.
     */
    public static function getVersion()
    {
        return self::VERSION;
    }

    /**
     * Return whether a value is a 32-character hexadecimal identifier.
     */
    public static function isUUid($str)
    {
        if (strlen($str) != 32) {
            return false;
        }
        return ctype_xdigit($str);
    }

    /**
     * Parse known services and retain the original bytes for signature verification.
     */
    public function parse($token)
    {
        // Clear the previous token state so a failed parse cannot reuse its signature or services.
        $this->parsed = false;
        $this->appId = "";
        $this->issueTs = 0;
        $this->expire = 0;
        $this->salt = 0;
        $this->services = [];
        $this->signature = "";
        $this->signingInfo = "";

        if (substr($token, 0, self::VERSION_LENGTH) != self::getVersion()) {
            return false;
        }

        $data = zlib_decode(base64_decode(substr($token, self::VERSION_LENGTH)));
        $this->signature = Util::unpackString($data);
        $this->signingInfo = $data;
        $this->services = [];
        $this->appId = Util::unpackString($data);
        $this->issueTs = Util::unpackUint32($data);
        $this->expire = Util::unpackUint32($data);
        $this->salt = Util::unpackUint32($data);
        $serviceNum = Util::unpackUint16($data);

        $serviceClasses = [
            ServiceRtc::SERVICE_TYPE => "ServiceRtc",
            ServiceRtm::SERVICE_TYPE => "ServiceRtm",
            ServiceFpa::SERVICE_TYPE => "ServiceFpa",
            ServiceChat::SERVICE_TYPE => "ServiceChat",
            ServiceApaas::SERVICE_TYPE => "ServiceApaas",
        ];
        for ($i = 0; $i < $serviceNum; $i++) {
            $serviceType = Util::unpackUint16($data);
            if (!isset($serviceClasses[$serviceType])) {
                $this->parsed = true;
                return true;
            }

            $serviceClass = $serviceClasses[$serviceType];
            $service = new $serviceClass();
            $service->unpack($data);
            $this->addService($service);
        }
        $this->parsed = true;
        return true;
    }

    /**
     * Verify the signature of a successfully parsed token.
     */
    public function verifySignature($appCertificate)
    {
        if (!$this->parsed || $this->signature === "" || $this->signingInfo === "") {
            return false;
        }
        if (!self::isUUid($this->appId) || !self::isUUid($appCertificate)) {
            return false;
        }

        $signing = $this->getSign($appCertificate);
        $signature = hash_hmac("sha256", $this->signingInfo, $signing, true);
        return hash_equals($this->signature, $signature);
    }

    /**
     * Return services in stable type order while preserving duplicate insertion order.
     */
    private function servicesForPacking()
    {
        $indexedServices = [];
        foreach ($this->services as $index => $service) {
            $indexedServices[] = [
                "index" => $index,
                "service" => $service,
            ];
        }

        usort($indexedServices, function ($left, $right) {
            $leftType = $left["service"]->getServiceType();
            $rightType = $right["service"]->getServiceType();
            if ($leftType == $rightType) {
                return $left["index"] - $right["index"];
            }
            return $leftType < $rightType ? -1 : 1;
        });

        return array_map(function ($entry) {
            return $entry["service"];
        }, $indexedServices);
    }
}
