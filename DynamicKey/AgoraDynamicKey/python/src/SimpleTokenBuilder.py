import os
import sys
from collections import OrderedDict

sys.path.append(os.path.join(os.path.dirname(__file__), '../src'))
from AccessToken import *

Role_Attendee = 1
Role_Publisher = 2
Role_Subscriber = 3
Role_Admin = 4

AttendeePrivileges = OrderedDict([
    (kJoinChannel, 0),
    (kPublishAudioStream, 0),
    (kPublishVideoStream, 0),
    (kPublishDataStream, 0)
])

PublisherPrivileges = OrderedDict([
    (kJoinChannel, 0),
    (kPublishAudioStream, 0),
    (kPublishVideoStream, 0),
    (kPublishDataStream, 0),
    (kPublishAudiocdn, 0),
    (kPublishVideoCdn, 0),
    (kInvitePublishAudioStream, 0),
    (kInvitePublishVideoStream, 0),
    (kInvitePublishDataStream, 0)
])

SubscriberPrivileges = OrderedDict([
    (kJoinChannel, 0),
    (kRequestPublishAudioStream, 0),
    (kRequestPublishVideoStream, 0),
    (kRequestPublishDataStream, 0)
])

AdminPrivileges = OrderedDict([
    (kJoinChannel, 0),
    (kPublishAudioStream, 0),
    (kPublishVideoStream, 0),
    (kPublishDataStream, 0),
    (kAdministrateChannel, 0)
])

RolePrivileges = OrderedDict([
    (Role_Attendee, AttendeePrivileges),
    (Role_Publisher, PublisherPrivileges),
    (Role_Subscriber, SubscriberPrivileges),
    (Role_Admin, AdminPrivileges)
])


class SimpleTokenBuilder:

    def __init__(self, appID, appCertificate, channelName, uid):
        self.token = AccessToken(appID, appCertificate, channelName, uid)

    def initPrivileges(self, role):
        self.token.messages = RolePrivileges[role]

    def initTokenBuilder(self, originToken):
        return self.token.fromString(originToken)

    def setPrivilege(self, privilege, expireTimestamp):
        self.token.messages[privilege] = expireTimestamp

    def removePrivilege(self, privilege):
        self.token.messages.pop(privilege)

    def buildToken(self):
        return self.token.build()
