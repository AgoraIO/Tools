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

service = {
    1: {
        'name': 'RTC',
        'privilege': {
            1: {'name': 'joinChannel'},
            2: {'name': 'publishAudioStream'},
            3: {'name': 'publishVideoStream'},
            4: {'name': 'publishDataStream'}
        }
    },
    2: {
        'name': 'RTM',
        'privilege': {
            1: {'name': 'login'}
        }
    },
    3: {
        'name': 'Streaming',
        'privilege': {
            1: {'name': 'publishMixStream'},
            2: {'name': 'publishRawStream'}
        }
    },
    4: {
        'name': 'FPA',
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
    6: {
        'name': 'FCDN',
        'privilege': {
            1: {'name': 'publish'},
            2: {'name': 'play'}
        }
    },
    7: {
        'name': 'APaaS',
        'privilege': {
            1: {'name': 'roomUser'},
            2: {'name': 'user'},
            3: {'name': 'app'}
        }
    },
    8: {
        'name': 'RTM2',
        'privilege': {
            1: {'name': 'login'}
        },
        'resource': {
            0: {'name': 'messageChannels'},
            1: {'name': 'streamChannels'},
            2: {'name': 'groupChannels'},
            3: {'name': 'serverGroups'},
            4: {'name': 'users'}
        },
        'permission': {
            0: {'name': 'read'},
            1: {'name': 'write'}
        }
    }
}


def check_expire(expire):
    """Return whether a timestamp has expired and its remaining seconds."""
    remain = expire - int(time.time())
    return remain < 0, remain


def get_expire_msg(expire):
    """Return a human-readable expiration status for a timestamp."""
    is_expired, remain = check_expire(expire)
    if is_expired:
        return 'expired'
    return 'will expire in %d seconds' % remain


def append_rtm2_permissions(lines, permissions, service_info):
    """Append formatted RTM2 resource-level permissions to the output lines."""
    lines.append('    permissions:')
    if not permissions.details:
        lines.append('      (none)')
        return

    for resource_type in sorted(permissions.details):
        resource_info = service_info['resource'].get(resource_type)
        resource_name = resource_info['name'] if resource_info else 'unknown'
        lines.append('      - %s (%d):' % (resource_name, resource_type))

        permission_map = permissions.details[resource_type]
        for permission_type in sorted(permission_map):
            permission_info = service_info['permission'].get(permission_type)
            permission_name = permission_info['name'] if permission_info else 'unknown'
            resources = permission_map[permission_type]
            resource_list = ', '.join(resources) if resources else '(none)'
            lines.append('        - %s (%d): %s' % (
                permission_name, permission_type, resource_list))


def parse_token(token):
    """Parse a Token007 token and return its known service information."""
    if token[:3] != '007':
        return ('\nToken007 parse result\n'
                '=====================\n\n'
                'Status : failed\n'
                'Reason : only Token007 is supported\n')

    access_token = AccessToken()
    try:
        if not access_token.from_string(token):
            return ('\nToken007 parse result\n'
                    '=====================\n\n'
                    'Status : failed\n'
                    'Reason : invalid token\n')
    except Exception as e:
        return ('\nToken007 parse result\n'
                '=====================\n\n'
                'Status : failed\n'
                'Reason : %s\n' % e)

    issue_ts = access_token._AccessToken__issue_ts
    expire = access_token._AccessToken__expire
    expire_ts = issue_ts + expire
    lines = [
        '',
        'Token007 parse result',
        '=====================',
        '',
        'Token',
        '-----',
        'Status          : success',
        'App ID          : %s' % access_token._AccessToken__app_id.decode(),
        'Issue timestamp : %d' % issue_ts,
        'Lifetime        : %d seconds' % expire,
        'Expire timestamp: %d (%s)' % (expire_ts, get_expire_msg(expire_ts)),
        'Salt            : %d' % access_token._AccessToken__salt,
        '',
        'Services (%d)' % len(access_token.services),
        '------------',
    ]

    for index, item in enumerate(access_token.services, start=1):
        service_type = item.service_type()
        service_info = service.get(service_type)
        if service_info is None:
            lines.append('[%d] Unknown (ServiceType: %d)' % (
                index, service_type))
            continue

        lines.append('[%d] %s (ServiceType: %d)' % (
            index, service_info['name'], service_type))

        for key, serviceItem in item.__dict__.items():
            if key in ('_Service__type', '_Service__privileges'):
                continue

            field_name = key.split('__', 1)[-1]
            if service_type == 8 and field_name == 'permissions':
                append_rtm2_permissions(lines, serviceItem, service_info)
                continue

            field_value = serviceItem.decode('utf-8', errors='replace') \
                if isinstance(serviceItem, bytes) else serviceItem
            lines.append('    %-15s: %s' % (field_name, field_value))

        lines.append('    privileges:')
        for privilege, privilege_expire in item._Service__privileges.items():
            privilege_info = service_info['privilege'].get(privilege)
            privilege_name = privilege_info['name'] if privilege_info else 'unknown'
            privilege_status = get_expire_msg(issue_ts + privilege_expire)
            lines.append('      - %s (%d): %d seconds (%s)' % (
                privilege_name, privilege, privilege_expire, privilege_status))

        lines.append('')

    return '\n'.join(lines).rstrip() + '\n'


if __name__ == "__main__":
    if len(sys.argv) > 1:
        token = sys.argv[1]
    else:
        token = '007eJxTYNi/pqL4zazPf+P2/HDX+9fA/KLX+6oIz5O5Wzw2vzTSPdqtwGBpbuDsaGyakmpmkGxiYmZimpSUmGqRaGRoamBmmGRs/P87S7IAHwOD/mEfBlYGRgYWIAbxmcAkM5hkAZMKDOYp5kbGZqapSZYWxiYWpsaW5qnGqcZplikmZgZJKSmJXAxGFhZGxiaGRubGTEBzICYhi7LARVkZmFBsQlbFDrQX0xV8DEX5+bnxpaWZKfElqcUlfAylxalFCP7//wBAqz0L'

    print(parse_token(token))
