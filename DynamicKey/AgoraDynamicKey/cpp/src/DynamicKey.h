#pragma once

#include "utils.h"

namespace agora { namespace tools {
    struct DynamicKey{
            struct SignatureContent{
                std::string appID;
                uint32_t unixTs;
                uint32_t randomInt ;
                std::string channelName;
                std::string pack(){
                    std::stringstream ss;
                    ss << std::setfill ('\0') << std::setw(32) << appID
                        << std::setfill ('0') << std::setw(10) << unixTs
                        << std::setfill ('0') << std::setw(8) << std::hex << randomInt
                        << channelName;
                    return ss.str();
                }
            };
        static const uint32_t DYNAMIC_KEY_LENGTH = SIGNATURE_LENGTH + APP_ID_LENGTH + UNIX_TS_LENGTH + RANDOM_INT_LENGTH;
        static const uint32_t SIGNATURE_OFFSET = 0;
        static const uint32_t APP_ID_OFFSET = SIGNATURE_LENGTH;
        static const uint32_t UNIX_TS_OFFSET = SIGNATURE_LENGTH+APP_ID_LENGTH;
        static const uint32_t RANDOM_INT_OFFSET = SIGNATURE_LENGTH+APP_ID_LENGTH+UNIX_TS_LENGTH;
        static std::string version() { return "001"; }
        std::string signature;
        std::string appID;
        uint32_t unixTs ;
        uint32_t randomInt;
        static std::string toString(const std::string& appID, const std::string& signature, uint32_t unixTs, uint32_t randomInt) 
        {
            std::stringstream ss;
            ss << signature
                << appID
                << std::setfill ('0') << std::setw(10) << unixTs
                << std::setfill ('0') << std::setw(8) << std::hex << randomInt;
            return ss.str();
        }

        bool fromString(const std::string& channelKeyString)
        {
            if (channelKeyString.length() != 90) {
                return false;
            }
            this->signature = channelKeyString.substr(SIGNATURE_OFFSET, SIGNATURE_LENGTH);
            this->appID = channelKeyString.substr(APP_ID_OFFSET, APP_ID_LENGTH);
            try {
                this->unixTs =std::stoul(channelKeyString.substr(UNIX_TS_OFFSET, UNIX_TS_LENGTH),nullptr, 10);
                this->randomInt =std::stoul(channelKeyString.substr(RANDOM_INT_OFFSET, RANDOM_INT_LENGTH),nullptr, 16);
            } catch(std::exception& e) {
                return false;
            }
            return true;
        }

    static std::string generateSignature(const std::string& appID, const std::string& appCertificate, const std::string& channelName, uint32_t unixTs, uint32_t randomInt)
    {
        SignatureContent signContent;
        signContent.appID = appID;
        signContent.unixTs = unixTs;
        signContent.randomInt = randomInt;
        signContent.channelName = channelName;
        return stringToHex(HmacSign(appCertificate, signContent.pack(), HMAC_LENGTH));
    }

    static std::string generate(const std::string& appID, const std::string& appCertificate, const std::string& channelName, uint32_t unixTs, uint32_t randomInt)   
    {                                                                                                                                                                  
        std::string signature = generateSignature(appID, appCertificate, channelName, unixTs, randomInt);

        return toString(appID, signature, unixTs, randomInt);                                                                                                                                  
    }
    };
}}
