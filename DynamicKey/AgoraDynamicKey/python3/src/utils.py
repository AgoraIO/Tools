import hashlib


def get_md5(data):
    """Return the hexadecimal MD5 digest of a UTF-8 encoded string."""
    h = hashlib.md5()
    h.update(data.encode('utf-8'))
    return h.hexdigest()
