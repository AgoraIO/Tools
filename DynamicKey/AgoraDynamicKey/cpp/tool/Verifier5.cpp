/**
 * build with command:
 * g++ Verifier5.cpp  -lcrypto -std=c++0x
 */
#include "../src/DynamicKey5.h"
#include <iostream>
#include <cstdint>
using namespace agora::tools;

template<typename T>
inline std::string map_to_string(const T & c, const std::string& separator)
{
    std::ostringstream oss;
    std::string s = "";
    for (const auto & v: c) {
        oss << s << v.first << ":" << v.second;
        s = separator;
    }

    return oss.str();
}

int main(int argc, char const *argv[]) {
    if (argc < 6) {
        std::cout << argv[0] << " appID appCertificate channelName uid key" << std::endl;
        return 0;
    }

    std::string appID = argv[1];
    std::string appCertificate = argv[2];
    std::string channelName = argv[3];
    uint32_t uid = strtoul(argv[4], NULL, 10);
    std::string keyString = argv[5];

    DynamicKey5 key5;
    key5.fromString(keyString);

    std::cout << std::endl;
    std::cout << "Service     " << key5.serviceType << std::endl;
    std::cout << "App ID:     " << key5.appID << std::endl;
    std::cout << "unixTs:     " << key5.unixTs << std::endl;
    std::cout << "expiredTs:  " << key5.expiredTs << std::endl;
    std::cout << "Extra:      [" << map_to_string(key5.extra, ", ") << "]" << std::endl;
    std::cout << "randomInt:  " << key5.randomInt << std::endl;
    std::cout << "Signature:  " << key5.signature << std::endl;
    std::cout << std::endl;

    std::cout << std::endl;
    std::cout << "Original \t " << keyString << std::endl;

    if (key5.serviceType == DynamicKey5::MEDIA_CHANNEL_SERVICE) {
        std::cout << "Uid = 0 \t " << DynamicKey5::generateMediaChannelKey(appID, appCertificate, channelName, key5.unixTs, key5.randomInt, 0, key5.expiredTs) << std::endl;
        std::cout << "Uid = " << uid << " \t " << DynamicKey5::generateMediaChannelKey(appID, appCertificate, channelName, key5.unixTs, key5.randomInt, uid, key5.expiredTs) << std::endl;
    } else if (key5.serviceType == DynamicKey5::RECORDING_SERVICE) {
        std::cout << "Uid = 0 \t " << DynamicKey5::generateRecordingKey(appID, appCertificate, channelName, key5.unixTs, key5.randomInt, 0, key5.expiredTs) << std::endl;
        std::cout << "Uid = " << uid << " \t " << DynamicKey5::generateRecordingKey(appID, appCertificate, channelName, key5.unixTs, key5.randomInt, uid, key5.expiredTs) << std::endl;
    } else if (key5.serviceType == DynamicKey5::IN_CHANNEL_PERMISSION) {
        std::string permission = key5.extra[DynamicKey5::ALLOW_UPLOAD_IN_CHANNEL];
        if (permission != DynamicKey5::noUpload() && permission != DynamicKey5::audioVideoUpload()) {
            std::cout << "Unknown in channel upload permission " << permission << " in extra [" << map_to_string(key5.extra, ", ") << "]" << std::endl;
            return 0;
        }
        std::cout << "Uid = 0 \t " << DynamicKey5::generateInChannelPermissionKey(appID, appCertificate, channelName, key5.unixTs, key5.randomInt, 0, key5.expiredTs, permission) << std::endl;
        std::cout << "Uid = " << uid << " \t " << DynamicKey5::generateInChannelPermissionKey(appID, appCertificate, channelName, key5.unixTs, key5.randomInt, uid, key5.expiredTs, permission) << std::endl;
    } else {
        std::cout << "Unknown service type " << key5.serviceType << std::endl;
    }

    return 0;
}
