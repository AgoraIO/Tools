Name
====
lua-resty-agoradynamickey: an optional lua resty lib AgoraDynamicKey 


Installation
============

Just place `agoradynamickey` directory somewhere in your package.path, under resty directory. If you are using OpenResty, the default location would be /usr/local/openresty/lualib/resty.

depend
------
> lua-struct

you can install with `luarocks`, or just place the `struct.lua` in your package.path,under resty directory.
```
luarocks install lua-struct
```

Table of Contents
=================

- [Name](#name)
- [Installation](#installation)
  - [depend](#depend)
- [Table of Contents](#table-of-contents)
- [Synopsis](#synopsis)
  - [new](#new)
  - [rtc_token_builder](#rtc_token_builder)
  - [rtm_token_builder](#rtm_token_builder)
- [See Also](#see-also)

Synopsis
========
```lua

    # you do not need the following line if you are using
    # the ngx_openresty bundle:
    lua_package_path "/path/to/lua-resty-mysql/lib/?.lua;;";

    server {
        location /test {
            content_by_lua '
                local access_token = require "resty.agoradynamickey.access_token"
                local app_id = "test_app_id"
                local app_certificate = "test_app_certificate"
                local channel_name = "test_channel_name"
                local uid = 123456
                local expire_ts = 1598881347
                local salt = 1
                local ts = 1598181347
                local expected = "006test_app_idIAA2vi1+SRyDQKacsKuTrwXuIM1Jbh1Nsk5dy2ipAH3t/Eg98e5h03IJEAABAAAA409CXwEAAQBD/kxf" 

                local token = access_token.new(app_id, app_certificate, channel_name, uid)
                token.salt = salt
                token.ts = ts
                token.messages[token.kJoinChannel] = expire_ts
                local result = token:build()
                ngx.say(result == expected)  -- true
            ';
        }
    }
```

Methods

=======
new
---
`syntax: token = access_token.new(options)`

Creates a access_token object.
The `options` argument is a Lua table holding the following keys:

* `app_id`

    the apple id.
* `app_certificate`

    the app certificate for your app account.
* `channel_name`

    the channel name you define in agora.
* `user_account`

    the user_account(number/string).
[Back to TOC](#table-of-contents)


rtc_token_builder
-----------------
`syntax: token = rtm_token_builder.build_token_with_uid(options)`

Creates a rtc access token to channel.
The `options` argument is a Lua table holding the following keys:

* `app_id`

    the apple id.
* `app_certificate`

    the app certificate for your app account.
* `channel_name`

    the channel name you define in agora.
* `user_account`

    the user_account(number/string).
* `role`

    the user role you define in agora.
* `privilege_expired_ts`

    the user token expire ts.
[Back to TOC](#table-of-contents)

rtm_token_builder
-----------------
`syntax: token = rtm_token_builder.build_token_with_uid(options)`

Creates a rtc access token to channel.
The `options` argument is a Lua table holding the following keys:

* `app_id`

    the apple id.
* `app_certificate`

    the app certificate for your app account.
* `channel_name`

    the channel name you define in agora.
* `user_account`

    the user_account(number/string).
* `role`

    the user role you define in agora.
* `privilege_expired_ts`

    the user token expire ts.
[Back to TOC](#table-of-contents)



[Back to TOC](#table-of-contents)
See Also
========
* the [lua-struct](https://github.com/iryont/lua-struct) library

[Back to TOC](#table-of-contents)