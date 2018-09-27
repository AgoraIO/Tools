#pragma once

#include "utils.h"

namespace agora { namespace tools {

    struct DynamicKey3{
        static const uint32_t DYNAMIC_KEY_LENGTH = VERSION_LENGTH+SIGNATURE_LENGTH + APP_ID_LENGTH + UNIX_TS_LENGTH + RANDOM_INT_LENGTH + UNIX_TS_LENGTH + UID_LENGTH ;
        static const uint32_t SIGNATURE_OFFSET = VERSION_LENGTH;
        static const uint32_t APP_ID_OFFSET = SIGNATURE_OFFSET + SIGNATURE_LENGTH;
        static const uint32_t UNIX_TS_OFFSET = VERSION_LENGTH+SIGNATURE_LENGTH+APP_ID_LENGTH;
        static const uint32_t RANDOM_INT_OFFSET = VERSION_LENGTH+SIGNATURE_LENGTH+APP_ID_LENGTH+UNIX_TS_LENGTH;
        static const uint32_t UID_INT_OFFSET = VERSION_LENGTH+SIGNATURE_LENGTH+APP_ID_LENGTH+UNIX_TS_LENGTH+RANDOM_INT_LENGTH;
        static const uint32_t EXPIREDTS_INT_OFFSET = VERSION_LENGTH+SIGNATURE_LENGTH+APP_ID_LENGTH+UNIX_TS_LENGTH+RANDOM_INT_LENGTH+UID_LENGTH;

        static std::string version() { return "003"; }

        std::string signature;
        std::string appID;
        uint32_t unixTs ;
        uint32_t randomInt;
        uint32_t uid;
        uint32_t expiredTs;
        static std::string toString(const std::string& appID, const std::string& signature,  uint32_t unixTs, uint32_t randomInt,uint32_t uid, uint32_t expiredTs) 
        {
            std::stringstream ss;
            ss  << DynamicKey3::version()
                << signature
                << appID
                << std::setfill ('0') << std::setw(10) << unixTs
                << std::setfill ('0') << std::setw(8) << std::hex << randomInt
                << std::setfill ('0') << std::setw(10) << std::dec<< uid
                << std::setfill ('0') << std::setw(10) << expiredTs;
            return ss.str();
        }
        bool fromString(const std::string& channelKeyString)
        {
              if (channelKeyString.length() != DYNAMIC_KEY_LENGTH) {
                  return false;
              }
              this->signature = channelKeyString.substr(SIGNATURE_OFFSET, SIGNATURE_LENGTH);
              this->appID = channelKeyString.substr(APP_ID_OFFSET, APP_ID_LENGTH);
              try {
                  this->unixTs = std::stoul(channelKeyString.substr(UNIX_TS_OFFSET, UNIX_TS_LENGTH), nullptr, 10);
                  this->randomInt = std::stoul(channelKeyString.substr(RANDOM_INT_OFFSET, RANDOM_INT_LENGTH), nullptr, 16);
                  this->uid = std::stoul(channelKeyString.substr(UID_INT_OFFSET, UID_LENGTH), nullptr, 10);
                  this->expiredTs = std::stoul(channelKeyString.substr(EXPIREDTS_INT_OFFSET, UNIX_TS_LENGTH), nullptr, 10);
              } catch(std::exception& e) {
                  return false;
              }
              return true;
          }

    static std::string generateSignature(const std::string& appID, const std::string& appCertificate, const std::string& channelName, uint32_t unixTs, uint32_t randomInt, uint32_t uid, uint32_t expiredTs)   {
        std::stringstream ss;
        ss << std::setfill ('\0') << std::setw(32) << appID
            << std::setfill ('0') << std::setw(10) << unixTs
            << std::setfill ('0') << std::setw(8) << std::hex << randomInt
            << channelName
            << std::setfill ('0') << std::setw(10) << std::dec<<uid
            << std::setfill ('0') << std::setw(10) << expiredTs;
        return stringToHex(HmacSign(appCertificate, ss.str(), HMAC_LENGTH));                 
    }

    static std::string generate(const std::string& appID, const std::string& appCertificate, const std::string& channelName, uint32_t unixTs, uint32_t randomInt, uint32_t uid, uint32_t expiredTs)   
    {                                                                                                                                                                  
        std::string signature = generateSignature(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs);
        return toString(appID, signature,  unixTs, randomInt, uid, expiredTs);                                                                                                                                  
    }

    };
}}
