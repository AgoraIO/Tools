<template>
  <v-app :class="text.lang">
    <!-- title bar -->
    <v-toolbar dark color="primary">
      <v-toolbar-title>{{text.toolbar_title}}</v-toolbar-title>
     
      <v-spacer></v-spacer>
      <v-btn v-on:click="copyLogs" color="info" >
        Download Logs
      </v-btn>
      <v-btn v-on:click="switchLanguage" color="blue" :disabled="languageDisabled">
        {{text.language}}
      </v-btn>
      <!-- <v-btn disabled flat icon>
        <v-icon>{{text.build}}</v-icon>
      </v-btn> -->
      <v-btn v-if="!testing" color="success" @click.native="start">
        {{text.start_text}}
      </v-btn>
      <v-btn v-else color="error" disabled>
        {{text.running}}
      </v-btn>

    </v-toolbar>
    <!-- end -->
    <v-content>
      <v-container fill-height>
        <v-layout row wrap fill-height>
          <!-- start page -->
          <v-flex md6 offset-md3 v-if="currentTestSuite < 0">
            <v-card style="margin-top: 60px">
              <v-card-title>
                <div class="headline">
                  {{text.following_step}}
                </div>
              </v-card-title>
              <v-card-text class="proxy">
                <v-label>{{text.cloudProxy}}</v-label>
                <v-btn-toggle mandatory v-model.lazy="isEnableCloudProxy" rounded>
                  <v-btn :value=true @click.native="toggleProxy(true)">{{text.cloudProxy_enable}}</v-btn>
                  <v-btn :value=false @click.native="toggleProxy(false)">{{text.cloudProxy_disable}}</v-btn>
                </v-btn-toggle>
              </v-card-text>
              <v-card-text class="proxy" v-if="isEnableCloudProxy">
                <v-label>{{text.cloudProxy_mode}}</v-label>
                <v-btn-toggle mandatory v-model.lazy="fixProxyMode" rounded>
                  <v-btn  :value=3 @click.native="setProxyMode(3)">{{text.cloudProxy_mode_3}}</v-btn>
                  <v-btn :value=4 @click.native="setProxyMode(4)">{{text.cloudProxy_mode_4}}</v-btn>
                  <v-btn :value=5 @click.native="setProxyMode(5)">{{text.cloudProxy_mode_5}}</v-btn>
                </v-btn-toggle>
                <v-card-text class="tip" v-if="fixProxyMode">
                  <span class="tip_icon"></span>{{text.cloudProxy_tips}}
                </v-card-text>
              </v-card-text>
              <v-card-text>
                <v-list>
                  <v-list-tile v-for="item in testSuites" :key="item.id">
                    <v-list-tile-content>
                      <v-list-tile-title>{{t(item.label)}}</v-list-tile-title>
                    </v-list-tile-content>
                  </v-list-tile>
                </v-list>
              </v-card-text>

            </v-card>
          </v-flex>
          <!-- result page -->
          <v-flex md6 offset-md3 v-else-if="currentTestSuite > 4">
            <v-card style="margin-top: 60px">
              <v-toolbar color="info" dark>
                <v-toolbar-title>
                  {{text.test_report}}
                </v-toolbar-title>
              </v-toolbar>
              <v-list>
                <v-list-group v-for="item in testSuites" :key="item.id">
                  <v-list-tile slot="activator">
                    <v-icon v-if="item.notError" color="success">done</v-icon>
                    <v-icon v-else color="error">close</v-icon>
                    <span>{{t(item.label)}}</span>
                  </v-list-tile>
                  <v-list-tile>
                    <v-list-tile-content v-html="item.extra"></v-list-tile-content>
                  </v-list-tile>
                </v-list-group>
              </v-list>
            </v-card>
          </v-flex>
          <!-- test suites -->
          <v-flex v-else>
            <v-stepper v-model="currentTestSuite">
              <v-stepper-header>
                <v-stepper-step class='bok' 
                  v-for="item in testSuites"
                  :key="item.id" :step="item.id"
                  :complete="item.complete || (currentTestSuite > item.id)"
                  :rules="[() => item.notError]">
                  {{t(item.label)}}
                </v-stepper-step>
              </v-stepper-header>

              <v-stepper-items style="background: #EEE">
                <!-- browser check -->
                <v-stepper-content step="0">
                  <v-container grid-list-md>
                    <v-layout row wrap>
                      <v-flex md6 xs12>
                        <v-card style="height: 100%" color="info" class="white--text">
                          <v-card-title>
                            <div class="headline">
                              {{text.browser_check}}
                            </div>
                          </v-card-title>
                          <v-card-text>
                            {{text.support_desc}}
                          </v-card-text>
                        </v-card>
                      </v-flex>
                      <v-flex md6 xs12>
                        <v-card style="height: 100%">
                          <v-card-title>
                            {{text.checking}} {{browserInfo}}
                          </v-card-title>
                          <v-card-text>
                            <v-progress-linear :indeterminate="true"></v-progress-linear>
                          </v-card-text>
                        </v-card>
                      </v-flex>
                    </v-layout>
                  </v-container>
                </v-stepper-content>
                <!-- microphone check -->
                <v-stepper-content step="1">
                  <v-container grid-list-md>
                    <v-layout row wrap>
                      <v-flex md6 xs12>
                        <v-card color="info" style="height: 100%" class="white--text">
                          <v-card-title>
                            <div class="headline">
                              {{text.microphone_check}}
                            </div>
                          </v-card-title>
                          <v-card-text>
                            {{text.microphone_check_desc}}
                          </v-card-text>
                        </v-card>
                      </v-flex>
                      <v-flex md6 xs12>
                        <v-card style="height: 100%">
                          <v-card-title>
                            {{text.microphone_volume_check_desc}}
                          </v-card-title>
                          <v-card-text>
                            <v-progress-linear :value="inputVolume"></v-progress-linear>
                          </v-card-text>
                        </v-card>
                      </v-flex>
                    </v-layout>
                  </v-container>
                </v-stepper-content>

                <!-- speaker check -->
                <v-stepper-content step="2">
                  <v-container grid-list-md>
                    <v-layout row wrap>
                      <v-flex md6 xs12>
                        <v-card color="info" class="white--text" style="height: 100%">
                          <v-card-title>
                            <div class="headline">{{text.speacker_check}}</div>
                          </v-card-title>
                          <v-card-text>
                            {{text.speaker_check_desc}}
                          </v-card-text>
                          <v-card-actions>
                            <v-btn @click="resolveCheck">{{text.yes}}</v-btn>
                            <v-btn flat @click="rejectCheck">{{text.no}}</v-btn>
                          </v-card-actions>
                        </v-card>
                      </v-flex>

                      <v-flex md6 xs12>
                        <v-card style="height: 100%">
                          <v-card-title>
                            <div class="headline">{{text.sample_music}}</div>
                          </v-card-title>
                          <v-card-text>
                            <audio id="sampleMusic" controls="controls">
                              <source src="./assets/music.mp3" type="audio/mp3">
                              {{text.sample_music_desc}}
                            </audio>
                          </v-card-text>
                        </v-card>
                      </v-flex>
                    </v-layout>
                  </v-container>
                </v-stepper-content>

                <!-- resolution check -->
                <v-stepper-content step="3">
                  <v-container grid-list-md>
                    <v-layout row wrap>
                      <v-flex md6 xs12>
                        <v-card color="info" class="white--text" style="height: 100%">
                          <v-card-title>
                            <div class="headline">{{text.resolution_check}}</div>
                          </v-card-title>
                          <v-card-text>
                            {{text.resolution_check_desc}}
                          </v-card-text>
                        </v-card>
                      </v-flex>

                      <v-flex md6 xs12>
                        <v-card style="height: 100%">
                          <v-card-title>
                            {{text.resolution_list}}
                          </v-card-title>
                          <v-card-text>
                            <v-list>
                              <v-list-tile v-for="(item, index) in profiles" :key="index">
                                <v-list-tile-content>
                                  {{`${item.width} * ${item.height}`}}
                                </v-list-tile-content>
                                <v-list-tile-action>
                                  <v-icon v-if="item.status==='resolve'" color="success">done</v-icon>
                                  <v-icon v-else-if="item.status==='reject'" color="error">close</v-icon>
                                  <v-icon v-else>more_horiz</v-icon>
                                </v-list-tile-action>
                              </v-list-tile>
                            </v-list>
                          </v-card-text>
                        </v-card>
                      </v-flex>
                    </v-layout>
                  </v-container>
                </v-stepper-content>
              </v-stepper-items>

                <!-- connection check -->
                <v-stepper-content step="4">
                  <v-container grid-list-md>
                    <v-layout row wrap>
                      <v-flex md12>
                        <v-card >
                          <v-card-title>
                            <div>{{text.network_check_desc}}</div>
                          </v-card-title>
                          <v-card-text v-if="renderChart">
                            <v-layout row wrap>
                              <v-flex md6 xs12>
                                <linechart :grid="grid" :data="bitrateData" :settings="bitrateChartSettings"></linechart>
                              </v-flex>
                              <v-flex md6 xs12>
                                <linechart :grid="grid" :data="packetsData" :settings="packetsChartSettings"></linechart>
                              </v-flex>
                            </v-layout>
                          </v-card-text>
                        </v-card>
                      </v-flex>
                    </v-layout>
                  </v-container>
                </v-stepper-content>
            </v-stepper>
            <!-- test area -->
            <div id="test-send"></div>
            <div id="test-recv"></div>
          </v-flex>
          <!-- snackbar -->
          <v-snackbar
            v-model="snackbar"
            color="info"
            :timeout="0"
            >
            {{text.notice}}
            <v-btn
              dark
              flat
              @click="haveATry"
            >
              {{text.yes}}
            </v-btn>
            <v-btn
              dark
              flat
              @click="snackbar = false"
            >
              {{text.no}}
            </v-btn>
          </v-snackbar>
          <!-- dialog -->

          <v-dialog v-model="dialog" persistent max-width="360">
            <v-card>
              <v-card-text>
                <div id="modal-video" v-if="!errMsgForTry">
                  <div v-if="!showVideo">{{text.videoText}}</div>
                </div>
                <div id="modal-remote-video" v-if="!errMsgForTry">
                  <div v-if="!showVideo">{{text.videoText}}</div>
                </div>
                <div>
                    <v-card-text>
                        <b>Channel</b> {{channel}} </br>
                        <b>UID</b> {{sendId}} <br>
                        <b>RUID</b> {{remoteid}}
                    </v-card-text>
                </div>
                <div style='margin-top: -20px;'>
                    <v-card-text class='url_link'>{{url}}</v-card-text>                                      
                    <span class="btn copy-btn " @click.stop.prevent="copyURL">
                     COPY URL TO CLIPBOARD
                     </span>
                    <input type="hidden" id="url-code" :value="url">
                </div>
              </v-card-text>
              <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn color="green darken-1" flat @click.native="endTry">{{text.close}}</v-btn>
              </v-card-actions>
            </v-card>
          </v-dialog>
<!--
          <v-dialog v-model="dialog" persistent max-width="360">
            <v-card>
              <v-card-title>
                <v-tabs>
                  <v-tab
                    v-for="(item, index) in ProfileForTry"
                    @click="retry(index)"
                    :key="index"
                  >
                    {{item.resolution}}
                  </v-tab>
                </v-tabs>
              </v-card-title>
              <v-card-text>
                <div id="modal-video" v-if="!errMsgForTry">
                  <div v-if="!showVideo">{{text.videoText}}</div>
                </div>
                <div v-else>{{errMsgForTry}}</div>
              </v-card-text>
              <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn color="green darken-1" flat @click.native="endTry">{{text.close}}</v-btn>
              </v-card-actions>
            </v-card>
          </v-dialog>
-->          
        </v-layout>
      </v-container>
    </v-content>
    
    <v-footer app height="auto">
      <v-card
        class="flex"
        flat
        tile
        color="grey lighten-5"
      >
        <v-card-text style="text-align:right">SDK {{text.Version}}: {{sdkVersion}}</v-card-text>
      </v-card>
    </v-footer>
  </v-app>
</template>

<script>
import  VConsole  from  'vconsole'
import AgoraRtc from "agora-rtc-sdk-ng";
import { Debugout } from 'debugout.js';
const langs = ['zh', 'en'];
import { profileArray, APP_ID } from "./utils/settings";
import * as i18n from './utils/i18n'

//const log = console.log.bind(console)
const logger = new Debugout()

// If need mobile phone terminal debugging
// let vConsole = new VConsole()
// log("testVConsole")

export default {
  name: "App",
  components: {
    linechart: () => import("./components/linechart.vue")
  },
  mounted() {
    document.title = this.text.toolbar_title
    this.parseUrl();
  },
  data() {
    return {
      grid: {
        left: 50
      },
      languageDisabled: false,
      browserInfo: navigator.appVersion || "Current Browser",
      language: navigator.language.match(/^zh/) ? 0 : 1,
      sdkVersion: AgoraRtc.VERSION,
      snackbar: false,
      showVideo: false,
      dialog: false,
      currentTestSuite: "-1",
      inputVolume: 0,
      renderChart: false,
      testing: false,
      isEnableCloudProxy: false,
      fixProxyMode: 0,
      isRemoteAdded : false,
      channel : null,
      sendId : 0,
      remoteid : 0,
      host : "http://localhost:8080",
      url : "http://localhost:8080",

      profiles: profileArray.map(item => {
        item.status = "pending";
        return item;
      }),
      testSuites: [
        {
          id: "0",
          label: "browser_compatibility",
          notError: true,
          extra: ""
        },
        {
          id: "1",
          label: "microphone",
          notError: true,
          extra: ""
        },
        {
          id: "2",
          label: "speaker",
          notError: true,
          extra: ""
        },
        {
          id: "3",
          label: "resolution",
          notError: true,
          extra: ""
        },
        {
          id: "4",
          label: "connection",
          notError: true,
          extra: ""
        }
      ],
      bitrateData: {
          columns: ['index', 'tVideoBitrate', 'tAudioBitrate'],
          rows: [
            { 
              index: 0, 
              'tVideoBitrate': 0, 
              'tAudioBitrate': 0 
            },
        ]
      },
      packetsData: {
        columns: ["index", 'tVideoPacketLoss', 'tAudioPacketLoss'],
        rows: [
          { 
            index: 0, 
            'tVideoPacketLoss': 0, 
            'tAudioPacketLoss': 0 
          }
        ]
      },
      errMsgForTry: "",
      ProfileForTry: [
        {
          resolution: "480p_1",
          isSuccess: false
        },
        {
          resolution: "720p_1",
          isSuccess: false
        },
      ],
      currentProfile: 0
    };
  },

  computed: {
    text() {
      const lang = langs[this.language] || 'en'
      const property = i18n[lang]['default']
      const obj = {}
      for (let key of Object.keys(property)) {
        Object.assign(obj, {
          [`${key}`]: property[key]
        })
      }
      return obj;
    },
    bitrateChartSettings() {
      return {
        yAxisName: [this.t('bitrate') + '(kbps)'],
        labelMap: {
          tVideoBitrate: this.t('Video_Bitrate'),
          tAudioBitrate: this.t('Audio_Bitrate')
        },
      }
    },
    packetsChartSettings() {
      return {
        yAxisType: ['percent'],
        yAxisName: [this.t('packet_loss')],
        labelMap: {
          tVideoPacketLoss: this.t('Video_Packet_Loss'),
          tAudioPacketLoss: this.t('Audio_Packet_Loss')
        },
      }
    },
  },

  methods: {
    t (key) {
      const lang = langs[this.language] || 'en'
      const property = i18n[lang]['default']
      return property[key]
    },

    switchLanguage () {
      this.language = this.language === 0 ? 1 : 0
    },

    copyLogs () {
      logger.downloadLog()
    },

    initialize() {
      this.ts = new Date().getTime();
      if (null == this.channel) {
        this.channel =
          String(this.ts).slice(7) +
          Math.floor(Math.random() * 1000000).toString(36);
      }

      logger.info("start initialize! channel id: ", this.channel);
      AgoraRtc.enableLogUpload();

      this.sendId = Number.parseInt(String(this.ts).slice(7), 10) * 10 + 1;
      this.recvId = Number.parseInt(String(this.ts).slice(7), 10) * 10 + 2;
      this.sendClient = AgoraRtc.createClient({ mode: 'live', codec: 'vp8' });
      this.recvClient = AgoraRtc.createClient({ mode: 'live', codec: 'vp8' });

      if(this.isEnableCloudProxy && this.fixProxyMode){
         logger.info("start setup proxy "+this.fixProxyMode);
        this.sendClient.startProxyServer(this.fixProxyMode);
        this.recvClient.startProxyServer(this.fixProxyMode);
      }

    },

    initSendClient() {

      return new Promise(async (resolve, reject) => {
      
       this.audioTrack && this.audioTrack.stop() && this.audioTrack.close();
       this.videoTrack && this.videoTrack.stop() && this.videoTrack.close();

       [this.audioTrack, this.videoTrack] = await AgoraRtc.createMicrophoneAndCameraTracks(
        {}, { encoderConfig: "720p_2" });

        // join 
        await this.sendClient.join(APP_ID, this.channel, null, this.sendId).catch(e => {
          console.error(" send join failed");
          logger.error(e);
          reject(e);
        });


        // publish
        await this.sendClient.setClientRole("host");
        await this.sendClient.publish([this.audioTrack, this.videoTrack]).catch(e => {
          console.error(" send publish failed");
          logger.error(e);
          reject(e);
        });

        resolve();
      });
    },

    initRecvClient() {

      return new Promise(async (resolve, reject) => {
        // join 
        await this.recvClient.join(APP_ID, this.channel, null, this.recvId).catch(e => {
            console.error(" recv join failed "+e.message);
            logger.error(e);
            reject(e);
          });



        this.recvClient.on("user-published",  async (user, mediaType) => {

          this.recvClient.subscribe(user, mediaType).then(response => {
            if (mediaType === 'video') {
              user.videoTrack.play("test-recv");
              let i = 1;
              this.detectInterval = setInterval(() => {

                const remoteTracksStats = {
                    video: this.recvClient.getRemoteVideoStats()[user.uid],
                    audio: this.recvClient.getRemoteAudioStats()[user.uid]
                  };

                    this.bitrateData.rows.push({
                      index: i,
                      tVideoBitrate: this._calcBitrate(
                        remoteTracksStats.video.receiveBytes , i
                      ),
                      tAudioBitrate: this._calcBitrate(
                        remoteTracksStats.audio.receiveBytes , i
                      )
                    });

                    this.packetsData.rows.push({
                      index: i,
                      tVideoPacketLoss: this._calcPacketLoss(
                      remoteTracksStats.video.receivePackets,
                      remoteTracksStats.video.receivePacketsLost                     
                      ),
                      tAudioPacketLoss: this._calcPacketLoss(
                      remoteTracksStats.audio.receivePackets,
                      remoteTracksStats.audio.receivePacketsLost
                      ),
                    });
                    i++;
              }, 1000);
            }
            if (mediaType === 'audio') {
              //user.audioTrack.play();
            } 
          }).catch(e => {
            console.error(9);
            logger.error(e);
          });
        });

            resolve();
      });
    },

    /**
     * @param {string} recvPackets
     * @param {string} recvPacketsLost
     */
    _calcPacketLoss(recvPackets, recvPacketsLost) {
      let recvPacketsNumber = Number(recvPackets);
      let recvPacketsLostNumber = Number(recvPacketsLost);
      let totalPacketsNumber = recvPacketsNumber + recvPacketsLostNumber
      if(totalPacketsNumber) {
        return Number((recvPacketsLostNumber / totalPacketsNumber).toFixed(4));
      } else {
        return '-'
      }
    },

    /**
     * @param {string} recvBytes
     * @param {number} seconds
     */
    _calcBitrate(recvBytes, seconds) {
      return Number.parseFloat(recvBytes / seconds / 1000 * 8).toFixed(2);
    },

    destructAll() {
      try {
        this.sendClient.unpublish(this.audioTrack);    
        this.sendClient.unpublish(this.videoTrack);
        this.audioTrack && this.audioTrack.stop() && this.audioTrack.close();
        this.videoTrack && this.videoTrack.stop() && this.videoTrack.close();
        this.sendClient.leave();
        this.recvClient.leave();
        clearInterval(this.detectInterval);
      } catch (err) {
        logger.error(err);
        throw(err);
      }
    },

  async  checkProfile(profile) {

      return new Promise(async (resolve, reject) => {

        this.audioTrack && this.audioTrack.stop() && this.audioTrack.close();
        this.videoTrack && this.videoTrack.stop() && this.videoTrack.close();

       [this.audioTrack, this.videoTrack] = await AgoraRtc.createMicrophoneAndCameraTracks(
        {}, { encoderConfig: profile.resolution });

        this.videoTrack.play("test-send");

        setTimeout(() => {
          let videoElement = document.querySelector(".agora_video_player");
          let videoArea = videoElement.videoWidth * videoElement.videoHeight
          let profileArea = profile.width * profile.height
          if (videoArea === profileArea) {
            profile.status = "resolve";
            resolve();
          } else {
            profile.status = "reject";
            reject("Resolution mismatched");
          }
        }, 2500);                  
      });
    },

    start() {
      if (!APP_ID) {
        alert("APP_ID cannot be empty!");
        return;
      }
      this.initialize();
      this.restore();
      this.testing = true;
      this.snackbar = false;
      this.dialog = false;
      this.languageDisabled = true;
      this.handleCompatibilityCheck();
    },

    parseUrl : function() {
      var oldUrl = window.location.href;
      if (oldUrl.indexOf("?") > 0) {
        this.host = oldUrl.split("?")[0];
        var componentsStr = oldUrl.split("?")[1];
        this.channel = componentsStr.split("channel=")[1].split("&")[0];
        this.fixProxyMode=   parseInt(componentsStr.split("proxy=")[1].split("&")[0]);
        if (this.fixProxyMode>0) {
          this.isEnableCloudProxy = 1;
        }
      }
    },

    restore() {
      this.testSuites.map(item => {
        item.notError = true;
        item.extra = "";
        item.complete = false;
      });
      this.currentTestSuite = "-1"
      this.inputVolume = 0
      this.renderChart = false
      this.testing = false
      this.profiles = profileArray.map(item => {
        item.status = "pending";
        return item;
      })
      this.bitrateData = {
        columns: ["index", 'tVideoBitrate', 'tAudioBitrate'],
        rows: [
          { 
            index: 0, 
            'tVideoBitrate': 0, 
            'tAudioBitrate': 0 
          }
        ]
      }
      this.packetsData = {
        columns: ["index", 'tVideoPacketLoss', 'tAudioPacketLoss'],
        rows: [
          { 
            index: 0, 
            'tVideoPacketLoss': 0, 
            'tAudioPacketLoss': 0 
          }
        ]
      }
    },

    handleCompatibilityCheck() {
      this.currentTestSuite = "0";
      let testSuite = this.testSuites["0"];
       this.bollok=22;
      setTimeout(() => {
        testSuite.notError = AgoraRtc.checkSystemRequirements();
        testSuite.notError
          ? (testSuite.extra = this.t("fully_supported"))
          : (testSuite.extra = this.t("some_functions_may_be_limited"));
        this.handleMicrophoneCheck();
      }, 6000);
    },

    async handleMicrophoneCheck() {

     this.currentTestSuite = "1";
     let testSuite = this.testSuites["1"];

     this.localAudioTrack = await AgoraRtc.createMicrophoneAudioTrack();
     //this.localAudioTrack.play("test-send");

     let totalVolume = 0;

      this.microphoneCheckTimer = setInterval(() => {
        this.inputVolume = Math.floor(
          this.localAudioTrack.getVolumeLevel() * 100
        );
        totalVolume += this.inputVolume;
      }, 100);

      setTimeout(() => {
        clearInterval(this.microphoneCheckTimer);
        this.localAudioTrack.close();
        if (totalVolume < 60) {
          testSuite.notError = false;
          testSuite.extra = this.t("can_barely_hear_you");
        } else {
          testSuite.extra = this.t("microphone_works_well");
        }
        this.handleSpeakerCheck();
      }, 7000);


    },

    handleSpeakerCheck() {
      this.currentTestSuite = "2";
    },

    resolveCheck() {
      let testSuite = this.testSuites[this.currentTestSuite];
      testSuite.extra = this.t('speaker_works_well');
      let sound = document.querySelector("#sampleMusic");
      sound.pause();
      sound.currentTime = 0;
      this.handleCameraCheck();
    },

    rejectCheck() {
      let testSuite = this.testSuites[this.currentTestSuite];
      testSuite.notError = false;
      testSuite.extra = this.t("speaker_wrong");
      let sound = document.querySelector("#sampleMusic");
      sound.pause();
      sound.currentTime = 0;
      this.handleCameraCheck();
    },

    toggleProxy(val) {
      this.isEnableCloudProxy = val;
    },

    setProxyMode(val) {
      this.fixProxyMode = val;
    },

    async handleCameraCheck() {
      this.currentTestSuite = "3";
      let testSuite = this.testSuites["3"];
      for (let item of this.profiles) {
        await this.checkProfile(item)
          .then(() => {
            this.sendStream && this.sendStream.close();
          })
          .catch(err => {
            logger.error(err);
            if (err === "Resolution mismatched") {
              testSuite.notError = false;
              testSuite.extra = err.msg;
              this.sendStream && this.sendStream.close();
            }
          });
      }

      if (this.profiles) {
        let arr = [];
        this.profiles.forEach(item => {
          let str = `${item.width} * ${item.height} ${
            this.t(item.status === "resolve" ? "support" : "not_support")
          }`;
          arr.push(str);
        });
        testSuite.extra = arr.join("</br>");
      }

      setTimeout(() => {
        this.handleConnectivityCheck();
      }, 1500);
    },

    async handleConnectivityCheck() {
      this.currentTestSuite = "4";
      let testSuite = this.testSuites["4"];
      // init client and stream
      try {
        await  Promise.all([
          Promise.race([
            this.initRecvClient(), 
            new Promise((resolve, reject) => {
                  setTimeout(() => {                   
                      reject(); // calls back to the catch block below
                  },10000);                  
              })
          ])         
        ]);
        
        await this.initSendClient();
        this.renderChart = true;
      } catch (err) {       
        if (this.isEnableCloudProxy==0) {
          alert("try again with proxy");
        }
        testSuite.extra = err; //"Connection Failed"
        testSuite.notError = false;

        setTimeout(() => {
          this.testing = false;
          this.currentTestSuite = "5";
          //this.snackbar = true;
        }, 1500); 
        return false;
      }
      // go on
      setTimeout(() => {
        this.destructAll();
        setTimeout(() => {
          this.testing = false;
          this.currentTestSuite = "5";
          this.snackbar = true;
          if (
            this.bitrateData.rows.length === 1 ||
            this.packetsData.rows.length === 1
          ) {
            testSuite.extra = "poor_connection";
            testSuite.notError = false;
          }
          if (this.bitrateData && this.packetsData) {
            let bitrateInfo = this.bitrateData.rows.pop();
            let packetInfo = this.packetsData.rows.pop();
          
            let videoBitrate = bitrateInfo.tVideoBitrate
            let audioBitrate = bitrateInfo.tAudioBitrate
            let videoPacketLoss = packetInfo.tVideoPacketLoss
            let audioPacketLoss = packetInfo.tAudioPacketLoss

            if(videoBitrate == 0 || audioBitrate == 0) {
               testSuite.notError = false;
            }
            if(videoPacketLoss !== '-') {
              videoPacketLoss = videoPacketLoss * 100
            }
            if(audioPacketLoss !== '-') {
              audioPacketLoss = audioPacketLoss * 100
            }
            testSuite.extra = `${ this.t('Video_Bitrate')}: ${ videoBitrate } kbps </br>
            ${ this.t('Audio_Bitrate')}: ${ audioBitrate } kbps </br>
            ${ this.t('Video_Packet_Loss')}: ${ videoPacketLoss } % </br>
            ${ this.t('Audio_Packet_Loss')}: ${ audioPacketLoss } % </br>`;
          }
        }, 1500);
      }, 3500);
    },
    fetchAndGetHostUrl : function() {
      const rest = window.location.href;
      if (rest.indexOf("?") > 0) {
        this.host = rest.split("?")[0];
      } else {
        this.host = rest;
      }
      let r = 0;
      if (this.isEnableCloudProxy>0) {
        r = this.fixProxyMode;
      }
      this.url = this.host + "?channel=" + this.channel + "&proxy=" + r
    },
    haveATry() {
      this.fetchAndGetHostUrl();
      this.snackbar = false;
      this.dialog = true;
      this.ProfileForTry.forEach((item) => {
        let index = this.profiles.findIndex((profile) => {
          return profile.resolution === item.resolution
        })
        if(index === -1) {
          return
        } 
        item.isSuccess = this.profiles[index].status === 'resolve'
      })
      this.retry();
    },

   async retry() {

      this.showVideo = true;
      this.audioTrack && this.audioTrack.stop() && this.audioTrack.close();
      this.videoTrack && this.videoTrack.stop() && this.videoTrack.close();

      [this.audioTrack, this.videoTrack] = await AgoraRtc.createMicrophoneAndCameraTracks(
        {}, { encoderConfig: "720p_1" });

      this.videoTrack.play("modal-video");

      // join 
      await this.sendClient.join(APP_ID, this.channel, null, this.sendId).catch(e => {
        console.error(" send join failed");
        return;
      });

      // subscribe 
      await this.sendClient.on("user-published",  async (user, mediaType) => {
        this.sendClient.subscribe(user, mediaType).then(response => {
          if (mediaType === 'video') {
            user.videoTrack.play("modal-remote-video");
          }
          if (mediaType === 'audio') {
            user.audioTrack.play();
          } 
        }).catch(e => {
          console.error("retry subscribe fail");
          logger.error(e);
        });
      });

      // publish
      await this.sendClient.setClientRole("host");
      await this.sendClient.publish([this.audioTrack, this.videoTrack]).catch(e => {
        console.error(" send publish failed");
        logger.error(e);
        reject(e);
      });
    },
    copyURL () {
        let testingCodeToCopy = document.querySelector('#url-code')
        testingCodeToCopy.setAttribute('type', 'text')    // 不是 hidden 才能複製
        testingCodeToCopy.select()

        try {
          var successful = document.execCommand('copy');
          var msg = successful ? 'successful' : 'unsuccessful';
          alert('URL was copied ' + msg);
        } catch (err) {
          alert('Oops, unable to copy');
          logger.error(err);
        }

        /* unselect the range */
        testingCodeToCopy.setAttribute('type', 'hidden')
        window.getSelection().removeAllRanges()
      },

    endTry() {
      this.dialog = false;
      this.audioTrack && this.audioTrack.stop() && this.audioTrack.close();
      this.videoTrack && this.videoTrack.stop() && this.videoTrack.close();
    }
  }
};
</script>

<style>
.zh .headline {
  font-size: 24px !important;
}
#test-send {
  width: 640px;
  height: 360px;
  position: fixed;
  right: -999999px;
}
#test-recv {
  width: 640px;
  height: 360px;
  position: fixed;
  right: -999999px;
}
#modal-video {
  width: 320px;
  height: 180px;
  margin: 10px;
}
#modal-remote-video {
  width: 320px;
  height: 180px;
  margin:  10px;
  background-color: #eee;
}
@-webkit-keyframes rotate {
  0% {
      -webkit-transform: rotate(0deg);
      transform: rotate(0deg)
  }

  100% {
      -webkit-transform: rotate(360deg);
      transform: rotate(360deg)
  }
}

@keyframes rotate {
  0% {
      -webkit-transform: rotate(0deg);
      transform: rotate(0deg)
  }

  100% {
      -webkit-transform: rotate(360deg);
      transform: rotate(360deg)
  }
}
.github { 
  cursor: pointer;
  background-repeat: no-repeat;
  position: absolute;
  background-image: url("./assets/github.png");
  background-size: 50px;
  display: block;
  width: 50px;
  height: 50px;
  margin: 20px;
  border-radius: 28px;
  transform: translateY(-40px);
  -webkit-box-reflect: below;
  -webkit-box-reflect:below 2px 
  -webkit-linear-gradient(90deg, rgba(0,0,0,0) 15%,rgba(0,0,0,0.5));
 }

.aperture {
  /* display: inline-block; */
  width: 58px !important;
  height: 58px !important;
  position: absolute;
  right: 260px;
  top: 28px;
  z-index: 1999;
}

.aperture::after {
    content: "";
    position: absolute;
    width: 100%;
    height: 100%;
    top: -24px;
    left: 16px;
    border-radius: 50%;
    box-shadow: inset 0 0 10px #fff06a, inset 4px 0 16px #f0f, inset -4px 0 16px #0ff, inset 4px 0 16px #f0f, inset -4px 0 16px #0ff, 0 0 10px #fff06a, -6px 0 36px #f0f, 6px 0 36px #0ff;
    -webkit-animation: rotate 3s infinite linear;
    animation: rotate 3s infinite linear;
}

.v-list__tile {
  min-height: 48px!important;
  height: auto!important;
}

.copy-btn{
  margin-left: 74px;
    /* font-weight: bold; */
    color: white;
    background-color: rgb(33, 150, 243);
    padding: 6px;
    font-family: Roboto, sans-serif;
    font-size: 14px;
    font-stretch: 100%;
    font-style: normal;
    font-weight: 700;
    cursor: pointer;
}

.url_link{
    color: black;
    width: 338px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    margin-top: -20px;
}

  .proxy {
    font-size: 12px;
    margin-left: 16px;
    margin-top: 12px;
    text-align: end;
    padding-right: 60px !important;
  }
  .proxy .v-label {
    color: #333333;
    width: 100px;
    display: block;
    float: left;
    line-height: 36px;
    height: 36px;
    text-align: start;
  }
  .proxy .v-btn__content {
    font-size: 12px;
  }
  .proxy .v-btn-toggle .v-btn{
    width: 80px;
  }
  .proxy .v-btn-toggle .v-btn.v-btn--active {
    background-color: dodgerblue;
    color: white;
  }
  .tip {
    color: #666666;
    font-size: 12px;
    padding-left: 36px;
  }
  .tip_icon{
    background-repeat: no-repeat;
    position: absolute;
    background-image: url("./assets/info.png");
    background-size: 18px;
    display: inline-block;
    width: 18px;
    height: 18px;
    margin-left: -24px;
  }
  .v-card__text {
    padding: 10px;
    width: 100%;
  }
  .v-card {
    min-width: 280px;
  }
   .error--text .material-icons {
  color: orange !important;
  }

   .error--text .v-stepper__label{
    color: black !important;
  }
</style>
