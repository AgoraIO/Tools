from src.TokenBuilder import *

appID = "789898fed94ae8a010acf782f569b7"
appCertificate = "dxffe342248c43c88da748c2141573a7"
sceneName = "scene1"
userId = "bob"
channelName = "test"
role = Role_Publisher
expireTimeInSeconds = 3600
streamId = "test"

currentTimestamp = int(time.time())
privilegeExpiredTs = currentTimestamp + expireTimeInSeconds


def test_generate_token():
    # Use a breakpoint in the code line below to debug your script.
    token = TokenBuilder.build_token_for_scene(appID, appCertificate, sceneName, userId, role, privilegeExpiredTs)
    print("user token: {0}".format(token))  # Press Ctrl+F8 to toggle the breakpoint.

    token = TokenBuilder.build_token_for_account(appID, appCertificate, sceneName, streamId, userId, role, privilegeExpiredTs)
    print("stream token: {0}".format(token))

    token = TokenBuilder.build_token_for_compatible(appID, appCertificate, channelName, userId, role, privilegeExpiredTs)
    print("compatible token: {}".format(token))


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    test_generate_token()

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
