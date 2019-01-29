#pragma once
#include <string>
#include <vector>
#include <unistd.h>
#include "cJSON.h"

const uint32_t MODE_BROADCAST = 0;
const uint32_t MODE_COMMUNICAT = 1;
const uint32_t ROLE_BROADCASTER = 0;
const uint32_t ROLE_AUDIENCE = 1;

class mute_stst_t
{
    public:
    bool local_video;
    bool local_audio;
    bool remote_video;
    bool remote_audio;
};

class video_profile_ex_t
{
    public:
    uint32_t width;
    uint32_t height;
    uint32_t fps;
    uint32_t kbps;
};

class settings_t
{
    public:
    settings_t(){}

    settings_t(const settings_t& other_settings)  
    {  
        key = other_settings.key;
        channel_name = other_settings.channel_name;
        uid = other_settings.uid;
        mode = other_settings.mode;
        role= other_settings.role;
        dual_stream = other_settings.dual_stream;
        web_interoperability = other_settings.web_interoperability;
        video_profile = other_settings.video_profile;
        video_profile_ex.width = other_settings.video_profile_ex.width;
        video_profile_ex.height = other_settings.video_profile_ex.height;
        video_profile_ex.fps = other_settings.video_profile_ex.fps;
        video_profile_ex.kbps = other_settings.video_profile_ex.kbps;
        audio_codec = other_settings.audio_codec;
        mute.local_video = other_settings.mute.local_video;
        mute.local_audio = other_settings.mute.local_audio;
        mute.remote_video = other_settings.mute.remote_video;
        mute.remote_audio = other_settings.mute.remote_audio;
        for (auto itor = other_settings.parameters.begin(); itor != other_settings.parameters.end(); itor++)
        {
            parameters.push_back(*itor);
        }
        video_file = other_settings.video_file;
        audio_file = other_settings.audio_file;
    }

    public:
    std::string key;
    std::string channel_name;
    int32_t uid;
    int32_t mode;
    int32_t role;
    bool dual_stream;
    bool web_interoperability;
    std::vector<std::string> parameters;
    int32_t video_profile;
    video_profile_ex_t video_profile_ex;
    std::string audio_codec;
    mute_stst_t mute;
    std::string video_file;
    std::string audio_file;
};

class json_parser
{
    public:
    json_parser(std::string global_settings, std::string golem_settings);
    ~json_parser();

    settings_t get_settings();

    private:
    void parse_global_settings(std::string global_settings);
    void parse_golem_settings(std::string golem_settings);

    private:
    settings_t settings_;
};