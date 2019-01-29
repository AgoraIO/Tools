import os
import re
import time
import json
import collections
import copy
from os import listdir

global_settings = ''
golem_settings = []
golems = []
interval = 0
configFile = r'./config.json'

def runCmd(s):
    # print s
    os.system(s + ' 2>&1')

def loadCfg():
    jsonfile = file(configFile)
    jsonobj = json.load(jsonfile)
    global global_settings
    global golem_settings
    global golems
    global interval

    global_settings = jsonobj["global_settings"]
    interval = jsonobj["global_settings"]["start_interval_sec"]

    for i in range(len(jsonobj["golem_settings"])):
        golem_settings.append(jsonobj["golem_settings"][i])

    for i in range(len(jsonobj["golems"])):
        golems.append(jsonobj["golems"][i])

    jsonfile.close

def runRobots():
    strPatternQuot = re.compile('\"')
    strPatternSpace = re.compile(' ')
    global_settings_text = json.dumps(global_settings, separators=(',',':'))
    global_settings_text = strPatternQuot.sub('\\"',global_settings_text)
    global_settings_text = strPatternSpace.sub('',global_settings_text)

    for i in range(len(golems)):
        golem_settings_text = json.dumps(golem_settings[golems[i]], separators=(',',':'))
        golem_settings_text = strPatternQuot.sub('\\"',golem_settings_text)
        golem_settings_text = strPatternSpace.sub('',golem_settings_text)

        print("\n############# ROBOT %d #############" %i)
        cmd = './Golem --global_settings %s --golem_settings %s &' % (global_settings_text, golem_settings_text)

        runCmd(cmd)
        time.sleep(interval)

loadCfg()
runRobots()