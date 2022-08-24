# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) Agora.io, Inc."

import sys
import time
from python3.src.AccessToken2 import AccessToken

# Parse token for version 007
#
# Usage
#     # python3 parse.py YOUR_TOKEN
#     # make parse token=YOUR_TOKEN
#
# Test token with web page
#     For RTC, https://webdemo.agora.io/agora-web-showcase/examples/Agora-Web-Tutorial-1to1-Web/
#     For RTM, https://webdemo.agora.io/agora-web-showcase/examples/Agora-RTM-Tutorial-Web/

service = {
    1: {
        'name': 'Rtc',
        'privilege': {
            1: {'name': 'joinChannel'},
            2: {'name': 'publishAudioStream'},
            3: {'name': 'publishVideoStream'},
            4: {'name': 'publishDataStream'}
        }
    },
    2: {
        'name': 'Rtm',
        'privilege': {
            1: {'name': 'login'}
        }
    },
    4: {
        'name': 'Fpa',
        'privilege': {
            1: {'name': 'login'}
        }
    },
    5: {
        'name': 'Chat',
        'privilege': {
            1: {'name': 'user'},
            2: {'name': 'app'}
        }
    },
    7: {
        'name': 'Education',
        'privilege': {
            1: {'name': 'roomUser'},
            2: {'name': 'user'},
            3: {'name': 'app'}
        }
    }
}


def check_expire(expire):
    remain = expire - int(time.time())
    return remain < 0, remain


def get_expire_msg(expire):
    is_expired, remain = check_expire(expire)
    if is_expired:
        return 'expired'
    return 'will expire in %d seconds' % remain


def parse_token(token):
    res = '\nToken is %s \n\n' % token

    if token[:3] != '007':
        return res + 'Not support, just for parsing token version 007!'

    access_token = AccessToken()
    try:
        access_token.from_string(token)
    except Exception as e:
        res += 'Parse token failed! %s \n' % e
        return res

    res += 'Parse token success! \n'
    res += 'Token information, %s. \n    - app_id:%s, issue_ts:%d, expire:%d, salt:%d \n' % (
        get_expire_msg(access_token._AccessToken__issue_ts + access_token._AccessToken__expire), access_token._AccessToken__app_id.decode(), access_token._AccessToken__issue_ts, access_token._AccessToken__expire, access_token._AccessToken__salt)

    for _, item in access_token._AccessToken__service.items():
        for key, serviceItem in item.__dict__.items():
            if key == '_Service__type':
                if item._Service__type not in service:
                    res += 'service type not existed, type:%d \n' % item._Service__type
                    continue
                res += '- Service information, type:%d (%s) \n' % (
                    item._Service__type, service[item._Service__type]['name'])
            elif key == '_Service__privileges':
                for privilege, privilegeExpire in item._Service__privileges.items():
                    res += '    - privilege:%d(%s), expire:%d (%s) \n' % (
                        privilege, service[item._Service__type]['privilege'][privilege]['name'], privilegeExpire,
                        get_expire_msg(access_token._AccessToken__issue_ts + privilegeExpire))
            else:
                res += '    - {}:{} \n'.format(key.replace('_Service%s__' % service[item._Service__type]['name'], ''),
                                               serviceItem.decode() if type(serviceItem) == bytes else serviceItem)

    return res


if __name__ == "__main__":
    if len(sys.argv) > 1:
        token = sys.argv[1]
    else:
        token = '007eJxTYNi/pqL4zazPf+P2/HDX+9fA/KLX+6oIz5O5Wzw2vzTSPdqtwGBpbuDsaGyakmpmkGxiYmZimpSUmGqRaGRoamBmmGRs/P87S7IAHwOD/mEfBlYGRgYWIAbxmcAkM5hkAZMKDOYp5kbGZqapSZYWxiYWpsaW5qnGqcZplikmZgZJKSmJXAxGFhZGxiaGRubGTEBzICYhi7LARVkZmFBsQlbFDrQX0xV8DEX5+bnxpaWZKfElqcUlfAylxalFCP7//wBAqz0L'
    
    print(parse_token(token))