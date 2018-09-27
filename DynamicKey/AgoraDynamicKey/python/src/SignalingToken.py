import hashlib


def generateSignalingToken(
        account,
        appID,
        appCertificate,
        expiredTsInSeconds
):
    version = "1"
    expired = str(expiredTsInSeconds)
    content = account + appID + appCertificate + expired
    md5sum = hashlib.md5(content).hexdigest()
    result = "%s:%s:%s:%s" % (version, appID, expired, md5sum)
    return result
