#! /usr/bin/python
# ! -*- coding: utf-8 -*-

import argparse
import sys
import os
import time
from random import randint

sys.path.append(os.path.join(os.path.dirname(__file__), '../src'))
from DynamicKey4 import generateRecordingKey
from DynamicKey4 import generateMediaChannelKey


def main():
    unixts = int(time.time())
    randomint = -2147483647

    parser = argparse.ArgumentParser(description='Generator for channel key')
    parser.add_argument("--app_id", dest="app_id", default="")
    parser.add_argument("--certificate", dest="certificate", default="")
    parser.add_argument("--channel_name", dest="channel_name", default="")
    parser.add_argument("--uid", dest="uid", type=int, default=0)
    parser.add_argument("--expired_ts", dest="expired_ts", type=int, default=0)

    args = parser.parse_args()

    if not args.app_id:
        print >> sys.stderr, "No APP ID is designated"
        return -1

    if not args.certificate:
        print >> sys.stderr, "No certificate is designated"
        return -1

    if not args.channel_name:
        print >> sys.stderr, "No channel name is degsignated"
        return -1

    print "Recording key:", generateRecordingKey(args.app_id, args.certificate, \
                                                 args.channel_name, unixts, randomint, args.uid, args.expired_ts)

    print "Channel key:", generateMediaChannelKey(args.app_id, args.certificate, \
                                                  args.channel_name, unixts, randomint, args.uid, args.expired_ts)


if __name__ == "__main__":
    main()
