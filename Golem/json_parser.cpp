#include <assert.h>
#include <iostream>
#include "json_parser.h"

json_parser::json_parser(std::string global_settings, std::string golem_settings)
{
    settings_.parameters.clear();

    parse_global_settings(global_settings);
    parse_golem_settings(golem_settings);
}

json_parser::~json_parser()
{
}

void json_parser::parse_global_settings(std::string global_settings)
{
    cJSON *root = nullptr;
    cJSON *mode_obj = nullptr;
    cJSON *item = nullptr;

    root = cJSON_Parse(global_settings.c_str());
    assert(root != nullptr);
    item = cJSON_GetObjectItem(root, "key");
    assert(item != nullptr);
    settings_.key = std::string(item->valuestring);
    item = cJSON_GetObjectItem(root, "channel_name");
    assert(item != nullptr);
    settings_.channel_name = std::string(item->valuestring);
    item = cJSON_GetObjectItem(root, "dual_stream");
    assert(item != nullptr);
    settings_.dual_stream = (bool)item->valueint;
    item = cJSON_GetObjectItem(root, "web_interoperability");
    assert(item != nullptr);
    settings_.web_interoperability = (bool)item->valueint;
    mode_obj = cJSON_GetObjectItem(root, "mode");
    assert(mode_obj != nullptr);
    {
        item = cJSON_GetObjectItem(mode_obj, "type");
        assert(item != nullptr);
    
        settings_.mode = std::string(item->valuestring) == std::string("broadcast") ? MODE_BROADCAST : MODE_COMMUNICAT;
        item = cJSON_GetObjectItem(mode_obj, "role");
        assert(item != nullptr);
    
        settings_.role = std::string(item->valuestring) ==  std::string("broadcaster") ? ROLE_BROADCASTER : ROLE_AUDIENCE;
    }
    cJSON_Delete(root);
}

void json_parser::parse_golem_settings(std::string golem_settings)
{
    cJSON *root = nullptr;
    cJSON *mute_obj = nullptr;
    cJSON *mute_remote_obj = nullptr;
    cJSON *mute_local_obj = nullptr;
    cJSON *parameters_obj = nullptr;
    cJSON *video_profile_ex_obj = nullptr;
    cJSON *item = nullptr;

    root = cJSON_Parse(golem_settings.c_str());
    assert(root != nullptr);
    item = cJSON_GetObjectItem(root, "video_profile");
    assert(item != nullptr);
    settings_.video_profile = item->valueint;
    item = cJSON_GetObjectItem(root, "audio_codec");
    assert(item != nullptr);
    settings_.audio_codec = std::string(item->valuestring);
    item = cJSON_GetObjectItem(root, "video_file");
    assert(item != nullptr);

    settings_.video_file = std::string(item->valuestring);
    item = cJSON_GetObjectItem(root, "audio_file");
    assert(item != nullptr);

    settings_.audio_file = std::string(item->valuestring);
    item = cJSON_GetObjectItem(root, "uid");
    assert(item != nullptr);
    settings_.uid = item->valueint;
    mute_obj = cJSON_GetObjectItem(root, "mute");
    assert(mute_obj != nullptr);
    {
        mute_remote_obj = cJSON_GetObjectItem(mute_obj, "remote");
        assert(mute_remote_obj != nullptr);
        {
            item = cJSON_GetObjectItem(mute_remote_obj, "video");
            assert(item != nullptr);
            settings_.mute.remote_video = (bool)item->valueint;
            item = cJSON_GetObjectItem(mute_remote_obj, "audio");
            assert(item != nullptr);
            settings_.mute.remote_audio = (bool)item->valueint;
        }
        mute_local_obj = cJSON_GetObjectItem(mute_obj, "local");
        assert(mute_local_obj != nullptr);
        {
            item = cJSON_GetObjectItem(mute_local_obj, "video");
            assert(item != nullptr);
            settings_.mute.local_video = (bool)item->valueint;
            item = cJSON_GetObjectItem(mute_local_obj, "audio");
            assert(item != nullptr);
            settings_.mute.local_audio = (bool)item->valueint;
        }
    }
    parameters_obj = cJSON_GetObjectItem(root, "parameters");
    assert(parameters_obj != nullptr);
    {
        int array_len = cJSON_GetArraySize(parameters_obj);
        for(int i = 0; i < array_len; i++)
        {
            item = cJSON_GetArrayItem(parameters_obj, i);
            assert(item != nullptr);
        
            settings_.parameters.push_back(std::string(cJSON_PrintUnformatted(item)));
        }
    }
    video_profile_ex_obj = cJSON_GetObjectItem(root, "video_profile_ex");
    assert(video_profile_ex_obj != nullptr);
    {
        item = cJSON_GetObjectItem(video_profile_ex_obj, "width");
        assert(item != nullptr);
        settings_.video_profile_ex.width = item->valueint;
        item = cJSON_GetObjectItem(video_profile_ex_obj, "height");
        assert(item != nullptr);
        settings_.video_profile_ex.height = item->valueint;
        item = cJSON_GetObjectItem(video_profile_ex_obj, "fps");
        assert(item != nullptr);
        settings_.video_profile_ex.fps = item->valueint;
        item = cJSON_GetObjectItem(video_profile_ex_obj, "kbps");
        assert(item != nullptr);
        settings_.video_profile_ex.kbps = item->valueint;
    }

    cJSON_Delete(root);
}

settings_t json_parser::get_settings()
{
    return settings_;
}