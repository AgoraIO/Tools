import sys
import os

sys.path.append(os.path.join(os.path.dirname(__file__), '../src'))
from AccessToken import *

class RtmTokenBuilder:

    def __init__(self, appID, appCertificate, userId):
        self.token = AccessToken(appID, appCertificate, userId, "")

    def initTokenBuilder(self, originToken):
        return self.token.fromString(originToken)

    def setPrivilege(self, privilege, expireTimestamp):
        self.token.messages[privilege] = expireTimestamp

    def removePrivilege(self, privilege):
        self.token.messages.pop(privilege)

    def buildToken(self):
        return self.token.build()
