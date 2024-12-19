package = "agora-token"
version = "0.1.0-1"
source = {
    url = "git+https://github.com/AgoraIO/Tools",
}
description = {
    summary = "Agora Token for lua",
    homepage = "https://github.com/AgoraIO/Tools/tree/master/DynamicKey/AgoraDynamicKey/lua",
    license = "MIT",
}
dependencies = {
    "base64",
    "luaossl",
    "luaunit",
    "lua-zlib",
    "md5"
}
build = {
    type = "builtin",
    modules = {
        ["agora_token.access_token"] = "src/access_token.lua",
        ["agora_token.apaas_token_builder"] = "src/apaas_token_builder.lua",
        ["agora_token.chat_token_builder"] = "src/chat_token_builder.lua",
        ["agora_token.education_token_builder"] = "src/education_token_builder.lua",
        ["agora_token.fpa_token_builder"] = "src/fpa_token_builder.lua",
        ["agora_token.rtc_token_builder"] = "src/rtc_token_builder.lua",
        ["agora_token.rtm_token_builder"] = "src/rtm_token_builder.lua",
        ["agora_token.utils"] = "src/utils.lua"
    }
}
