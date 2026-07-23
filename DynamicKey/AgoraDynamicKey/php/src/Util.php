<?php

/**
 * Provide binary packing, unpacking, and legacy test assertion helpers.
 */
class Util
{
    /**
     * Print whether two values are equal for legacy tests.
     */
    public static function assertEqual($expected, $actual)
    {
        $debug = debug_backtrace();
        $info = "\n- File:" . basename($debug[1]["file"]) . ", Func:" . $debug[1]["function"] . ", Line:" . $debug[1]["line"];
        if ($expected != $actual) {
            echo $info . "\n  Assert failed" . "\n    Expected :" . $expected . "\n    Actual   :" . $actual;
        } else {
            echo $info . "\n  Assert ok";
        }
    }

    /**
     * Pack an unsigned 16-bit integer in little-endian order.
     */
    public static function packUint16($x)
    {
        return pack("v", $x);
    }

    /**
     * Unpack an unsigned 16-bit integer and consume its bytes.
     */
    public static function unpackUint16(&$data)
    {
        $up = unpack("v", substr($data, 0, 2));
        $data = substr($data, 2);
        return $up[1];
    }

    /**
     * Pack an unsigned 32-bit integer in little-endian order.
     */
    public static function packUint32($x)
    {
        return pack("V", $x);
    }

    /**
     * Unpack an unsigned 32-bit integer and consume its bytes.
     */
    public static function unpackUint32(&$data)
    {
        $up = unpack("V", substr($data, 0, 4));
        $data = substr($data, 4);
        return $up[1];
    }

    /**
     * Pack a signed 16-bit integer in machine byte order.
     */
    public static function packInt16($x)
    {
        return pack("s", $x);
    }

    /**
     * Unpack a signed 16-bit integer and consume its bytes.
     */
    public static function unpackInt16(&$data)
    {
        $up = unpack("s", substr($data, 0, 2));
        $data = substr($data, 2);
        return $up[1];
    }

    /**
     * Pack a string with an unsigned 16-bit length prefix.
     */
    public static function packString($str)
    {
        return self::packUint16(strlen($str)) . $str;
    }

    /**
     * Unpack a length-prefixed string and consume its bytes.
     */
    public static function unpackString(&$data)
    {
        $len = self::unpackUint16($data);
        $up = unpack("C*", substr($data, 0, $len));
        $data = substr($data, $len);
        return implode(array_map("chr", $up));
    }

    /**
     * Pack an integer map in stable key order.
     */
    public static function packMapUint32($arr)
    {
        ksort($arr);
        $kv = "";
        foreach ($arr as $key => $val) {
            $kv .= self::packUint16($key) . self::packUint32($val);
        }
        return self::packUint16(count($arr)) . $kv;
    }

    /**
     * Unpack an integer map and consume its bytes.
     */
    public static function unpackMapUint32(&$data)
    {
        $len = self::unpackUint16($data);
        $arr = [];
        for ($i = 0; $i < $len; $i++) {
            $arr[self::unpackUint16($data)] = self::unpackUint32($data);
        }
        return $arr;
    }
}
