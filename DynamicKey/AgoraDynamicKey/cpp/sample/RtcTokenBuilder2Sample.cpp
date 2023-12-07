// Copyright (c) 2014-2017 Agora.io, Inc.
//

#include <iostream>

#include "../src/RtcTokenBuilder2.h"

using namespace agora::tools;

int main(int argc, char const *argv[])
{
    (void)argc;
    (void)argv;

    std::string app_id = "970CA35de60c44645bbae8a215061b33";
    std::string app_certificate = "5CFd2fd1755d40ecb72977518be15d3b";
    std::string channel_name = "7d72365eb983485397e3e3f9d460bdda";

    uint32_t uid = 2882341273;
    std::string account = "2882341273";

    uint32_t token_expiration_in_seconds = 3600;
    uint32_t privilege_expiration_in_seconds = 3600;
    uint32_t join_channel_privilege_expiration_in_seconds = 3600;
    uint32_t pub_audio_privilege_expiration_in_seconds = 3600;
    uint32_t pub_video_privilege_expiration_in_seconds = 3600;
    uint32_t pub_data_stream_privilege_expiration_in_seconds = 3600;

    std::string result;
    result = RtcTokenBuilder2::BuildTokenWithUid(
        app_id, app_certificate, channel_name, uid, UserRole::kRolePublisher,
        token_expiration_in_seconds, privilege_expiration_in_seconds);
    std::cout << "Token With Int Uid:" << result << std::endl;

    result = RtcTokenBuilder2::BuildTokenWithUserAccount(
        app_id, app_certificate, channel_name, account, UserRole::kRolePublisher,
        token_expiration_in_seconds, privilege_expiration_in_seconds);
    std::cout << "Token With UserAccount:" << result << std::endl;

    result = RtcTokenBuilder2::BuildTokenWithUid(
        app_id, app_certificate, channel_name, uid, token_expiration_in_seconds,
        join_channel_privilege_expiration_in_seconds, pub_audio_privilege_expiration_in_seconds,
        pub_video_privilege_expiration_in_seconds, pub_data_stream_privilege_expiration_in_seconds);
    std::cout << "Token With Int Uid:" << result << std::endl;

    result = RtcTokenBuilder2::BuildTokenWithUserAccount(
        app_id, app_certificate, channel_name, account, token_expiration_in_seconds,
        join_channel_privilege_expiration_in_seconds, pub_audio_privilege_expiration_in_seconds,
        pub_video_privilege_expiration_in_seconds, pub_data_stream_privilege_expiration_in_seconds);
    std::cout << "Token With UserAccount:" << result << std::endl;

    return 0;
}
