#pragma once

#include "Packer.h"
#include "utils.h"
#include <iostream>

namespace agora { namespace tools {
    struct DynamicKey5 {
        enum ServiceType: uint16_t {
            MEDIA_CHANNEL_SERVICE = 1,
            RECORDING_SERVICE = 2,
            PUBLIC_SHARING_SERVICE = 3,
            IN_CHANNEL_PERMISSION = 4,
        };

        enum InChannelPermissionKey: uint16_t {
            ALLOW_UPLOAD_IN_CHANNEL = 1,
        };

        static std::string version() { return "005"; }
        static std::string noUpload() { return "0"; }
        static std::string audioVideoUpload() { return "3"; }

        typedef std::map<uint16_t, std::string> extra_map;
        TOOLS_DECLARE_PACKABLE_8(Message, uint16_t,serviceType, std::string,appID, uint32_t,unixTs, uint32_t,salt, std::string,channelName, uint32_t,uid, uint32_t,expiredTs, extra_map,extra);
        TOOLS_DECLARE_PACKABLE_7(DynamicKey5Content, uint16_t,serviceType, std::string,signature, std::string,appID, uint32_t,unixTs, uint32_t,randomInt, uint32_t,expiredTs, extra_map,extra);

        std::string signature;
        std::string appID;
        uint32_t unixTs ;
        uint32_t randomInt;
        uint32_t expiredTs;
        extra_map extra;
        uint16_t serviceType;

        template<typename T>
        static std::string pack(const T& x)
        {
            Packer p;
            p << x;
            return p.pack().body();
        }

        template<typename T>
        static void unpack(const std::string& data, T& x)
        {
            Unpacker u(data.data(), data.length());
            u >> x;
        }

        bool fromString(const std::string& channelKeyString)
        {
            if (channelKeyString.substr(0, VERSION_LENGTH) != version()) {
                return false;
            }

            std::string rawContent = base64Decode(channelKeyString.substr(VERSION_LENGTH));
            if (rawContent.empty()) {
                return false;
            }

            DynamicKey5Content content;
            try {
              unpack(rawContent, content);
            } catch (std::overflow_error &e) {
              return false;
            }

            this->signature = content.signature;
            this->appID = stringToHEX(content.appID);
            this->unixTs = content.unixTs;
            this->randomInt = content.randomInt;
            this->expiredTs = content.expiredTs;
            this->extra = content.extra;
            this->serviceType = content.serviceType;
            return true;
        }

        static std::string generateSignature(const std::string& appCertificate, ServiceType service, const std::string& appID, uint32_t unixTs, uint32_t salt, const std::string& channelName, uint32_t uid, uint32_t expiredTs, const extra_map& extra)
        {
            // decode hex to avoid case problem
            std::string rawAppID = hexDecode(appID);
            std::string rawAppCertificate = hexDecode(appCertificate);

            Message m(service, rawAppID, unixTs, salt, channelName, uid, expiredTs, extra);
            std::string toSign = pack(m);
            return stringToHEX(HmacSign(rawAppCertificate, toSign, HMAC_LENGTH));
        }

        static bool isUUID(const std::string& v)
        {
            if (v.length() != 32) {
                return false;
            }

            for (char x : v) {
                if (! isxdigit(x)) {
                    return false;
                }
            }

            return true;
        }

        static std::string generateDynamicKey(
                const std::string& appID
                , const std::string& appCertificate
                , const std::string& channelName
                , uint32_t unixTs
                , uint32_t randomInt
                , uint32_t uid
                , uint32_t expiredTs
                , const extra_map& extra
                , ServiceType service
                )
        {
            if (! isUUID(appID)) {
                perror("invalid appID");
                return "";
            }

            if (! isUUID(appCertificate)) {
                perror("invalid appCertificate");
                return "";
            }

            std::string  signature = generateSignature(appCertificate, service, appID, unixTs, randomInt, channelName, uid, expiredTs, extra);
            DynamicKey5Content content(service, signature, hexDecode(appID), unixTs, randomInt, expiredTs, extra);
            return version() + base64Encode(pack(content));
        }

        static std::string generateMediaChannelKey(const std::string& appID
            , const std::string& appCertificate
            , const std::string& channelName
            , uint32_t unixTs
            , uint32_t randomInt
            , uint32_t uid
            , uint32_t expiredTs)   
        {
            return generateDynamicKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs, extra_map(), MEDIA_CHANNEL_SERVICE);
        }

        /*
         * NOTE: For ARS only, not Recording SDK(Linux). generateMediaChannelKey is for Recording SDK.
         */
        static std::string generateRecordingKey(const std::string& appID, const std::string& appCertificate, const std::string& channelName, uint32_t unixTs, uint32_t randomInt, uint32_t uid, uint32_t expiredTs)   
        {            
            return generateDynamicKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs, extra_map(), RECORDING_SERVICE);
        }

        static std::string generatePublicSharingKey(const std::string& appID, const std::string& appCertificate, const std::string& channelName, uint32_t unixTs, uint32_t randomInt, uint32_t uid, uint32_t expiredTs)   
        {
            return generateDynamicKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs, extra_map(), PUBLIC_SHARING_SERVICE);
        }

        static std::string generateInChannelPermissionKey(const std::string& appID, const std::string& appCertificate, const std::string& channelName, uint32_t unixTs, uint32_t randomInt, uint32_t uid, uint32_t expiredTs, const std::string& permission)
        {
            extra_map extra;
            extra[ALLOW_UPLOAD_IN_CHANNEL] = permission;
            return generateDynamicKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs, extra, IN_CHANNEL_PERMISSION);
        }

    };
}}
