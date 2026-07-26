<template>
  <v-app :class="text.lang">
    <!-- title bar -->
    <v-toolbar dark color="primary">
      <v-toolbar-title>{{text.toolbar_title}}</v-toolbar-title>
      <a href="https://github.com/AgoraIO/Tools/tree/master/TroubleShooting/Agora-WebRTC-Troubleshooting" class="aperture">
      <span class="github"></span>
      </a>
      <v-spacer></v-spacer>
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
                <v-btn-toggle v-model.lazy="isEnableCloudProxy" rounded>
                  <v-btn :value=true @click.native="toggleProxy(true)">{{text.cloudProxy_enable}}</v-btn>
                  <v-btn :value=false @click.native="toggleProxy(false)">{{text.cloudProxy_disable}}</v-btn>
                </v-btn-toggle>
              </v-card-text>
              <v-card-text class="proxy" v-if="isEnableCloudProxy">
                <v-label>{{text.cloudProxy_mode}}</v-label>
                <v-btn-toggle v-model.lazy="fixProxyPort" rounded>
                  <v-btn :value=false @click.native="toggleProxyMode(false)">{{text.cloudProxy_default}}</v-btn>
                  <v-btn :value=true @click.native="toggleProxyMode(true)">{{text.cloudProxy_fix}}</v-btn>
                </v-btn-toggle>
                <v-card-text class="tip" v-if="fixProxyPort">
                  <span class="tip_icon"></span>{{text.cloudProxy_tips}}
                  <a href="https://docs.agora.io/cn/Audio%20Broadcast/cloud_proxy_web?platform=Web">{{text.cloudProxy_tips_link}}</a>
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
                    <v-list-tile-content>
                      <span v-html="item.extra"></span>
                    </v-list-tile-content>
                  </v-list-tile>
                </v-list-group>
              </v-list>
            </v-card>
          </v-flex>
          <!-- test suites -->
          <v-flex v-else>
            <v-stepper v-model="currentTestSuite">
              <v-stepper-header>
                <v-stepper-step
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
import AgoraRtc from "agora-rtc-sdk-ng";
import LineChart from "./components/linechart.vue";
const langs = ['zh', 'en'];
import {
  APP_CERTIFICATE,
  APP_ID,
  TOKEN_ENDPOINT,
  TOKEN_EXPIRE,
  TOKEN_SRC,
  profileArray
} from "./utils/settings";
import * as i18n from './utils/i18n'

// If need mobile phone terminal debugging
// import VConsole from 'vconsole'
// new VConsole()

export default {
  name: "App",
  components: {
    linechart: LineChart
  },
  mounted() {
    document.title = this.text.toolbar_title
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
      fixProxyPort: false,
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
      sendClient: null,
      recvClient: null,
      sendStream: null,
      sendAudioTrack: null,
      sendVideoTrack: null,
      sendTracks: [],
      recvAudioTrack: null,
      recvVideoTrack: null,
      connectivityFinished: false,
      ProfileForTry: [
        {
          resolution: "480p_1",
          isSuccess: false
        },
        {
          resolution: "720p_1",
          isSuccess: false
        },
        {
          resolution: "1080p_1",
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

    initialize() {
      this.ts = new Date().getTime();
      this.channel =
        String(this.ts).slice(7) +
        Math.floor(Math.random() * 1000000).toString(36);
      this.sendId = Number.parseInt(String(this.ts).slice(7), 10) * 10 + 1;
      this.recvId = Number.parseInt(String(this.ts).slice(7), 10) * 10 + 2;
      this.sendClient = AgoraRtc.createClient({ mode: 'live', codec: 'h264' });
      this.recvClient = AgoraRtc.createClient({ mode: 'live', codec: 'h264' });
      if(this.isEnableCloudProxy && this.fixProxyPort){
        this.sendClient.startProxyServer(5);
        this.recvClient.startProxyServer(5);
      }
      else if(this.isEnableCloudProxy && !this.fixProxyPort){
        this.sendClient.startProxyServer();
        this.recvClient.startProxyServer();
      }
    },

    async initSendClient() {
      const token = await this.generateRtcToken(this.sendId);
      const tracks = await AgoraRtc.createMicrophoneAndCameraTracks(
        {},
        { encoderConfig: "720p_2" }
      );
      this.sendAudioTrack = tracks[0];
      this.sendVideoTrack = tracks[1];
      this.sendTracks = tracks;
      this.sendStream = this.sendVideoTrack;
      await this.sendClient.join(APP_ID, this.channel, token, this.sendId);
      await this.sendClient.setClientRole("host");
      await this.sendClient.publish(this.sendTracks);
    },

    async initRecvClient() {
      const token = await this.generateRtcToken(this.recvId);
      this.recvClient.on("user-published", async (user, mediaType) => {
        try {
          const track = await this.recvClient.subscribe(user, mediaType);
          if (mediaType === "video") {
            this.recvVideoTrack = track;
            this.recvVideoTrack.play("test-recv");
          } else if (mediaType === "audio") {
            this.recvAudioTrack = track;
          }
          this.startStatsDetection();
        } catch (err) {
          this.handleConnectivityError(err);
        }
      });
      this.recvClient.on("user-unpublished", () => {
        this.handleConnectivityError(new Error("Disconnected"));
      });
      this.recvClient.on("user-left", () => {
        this.handleConnectivityError(new Error("Disconnected"));
      });
      await this.recvClient.join(APP_ID, this.channel, token, this.recvId);
    },

    async generateRtcToken(uid) {
      if (!APP_CERTIFICATE) {
        return null;
      }
      const response = await fetch(TOKEN_ENDPOINT, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          appId: APP_ID,
          appCertificate: APP_CERTIFICATE,
          channelName: this.channel,
          expire: TOKEN_EXPIRE,
          src: TOKEN_SRC,
          type: 1,
          uid: String(uid)
        })
      });
      if (!response.ok) {
        throw new Error(`Token request failed: HTTP ${response.status}`);
      }
      const result = await response.json();
      if (result.code !== 0) {
        throw new Error(result.tip || result.msg || `Token request failed: code ${result.code}`);
      }
      if (!result.data || !result.data.token) {
        throw new Error('Token response missing data.token');
      }
      return result.data.token;
    },

    errorMessage(err) {
      return err && (err.msg || err.message) ? (err.msg || err.message) : String(err);
    },

    startStatsDetection() {
      if (this.detectInterval || !this.recvAudioTrack || !this.recvVideoTrack) {
        return;
      }
      let i = 1;
      this.detectInterval = setInterval(() => {
        const videoStatsMap = this.recvClient.getRemoteVideoStats();
        const audioStatsMap = this.recvClient.getRemoteAudioStats();
        const videoStats = videoStatsMap[String(this.sendId)] || Object.values(videoStatsMap)[0] || {};
        const audioStats = audioStatsMap[String(this.sendId)] || Object.values(audioStatsMap)[0] || {};
        this.bitrateData.rows.push({
          index: i,
          tVideoBitrate: Number(((videoStats.receiveBitrate || 0) / 1000).toFixed(2)),
          tAudioBitrate: Number(((audioStats.receiveBitrate || 0) / 1000).toFixed(2))
        });
        this.packetsData.rows.push({
          index: i,
          tVideoPacketLoss: this._calcPacketLoss(
            videoStats.receivePackets,
            videoStats.receivePacketsLost
          ),
          tAudioPacketLoss: this._calcPacketLoss(
            audioStats.receivePackets,
            audioStats.receivePacketsLost
          ),
        });
        i++;
      }, 1000);
    },

    handleConnectivityError(err) {
      if (this.connectivityFinished) {
        return;
      }
      clearInterval(this.detectInterval);
      this.detectInterval = null;
      this.bitrateData = {};
      this.packetsData = {};
      this.testSuites["4"].notError = false;
      this.testSuites["4"].extra = this.errorMessage(err);
      this.destructAll();
      this.currentTestSuite = "5";
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

    closeLocalTrack(track) {
      if (!track) {
        return;
      }
      try {
        track.stop && track.stop();
        track.close && track.close();
      } catch (err) {
        // Closing tracks is best-effort during cleanup.
      }
    },

    closeLocalTracks(tracks) {
      (tracks || []).forEach(track => {
        this.closeLocalTrack(track);
      });
    },

    closeRemoteTrack(track) {
      try {
        track && track.stop && track.stop();
      } catch (err) {
        // Remote playback cleanup is best-effort.
      }
    },

    destructAll() {
      clearInterval(this.detectInterval);
      this.detectInterval = null;
      this.closeLocalTracks(this.sendTracks);
      this.closeLocalTrack(this.sendStream);
      this.closeRemoteTrack(this.recvAudioTrack);
      this.closeRemoteTrack(this.recvVideoTrack);
      if (this.sendClient) {
        this.sendClient.unpublish(this.sendTracks).catch(() => {});
        this.sendClient.leave().catch(() => {});
      }
      if (this.recvClient) {
        this.recvClient.leave().catch(() => {});
      }
      if(this.isEnableCloudProxy){
        this.sendClient && this.sendClient.stopProxyServer();
        this.recvClient && this.recvClient.stopProxyServer();
      }
      this.sendStream = null;
      this.sendAudioTrack = null;
      this.sendVideoTrack = null;
      this.sendTracks = [];
      this.recvAudioTrack = null;
      this.recvVideoTrack = null;
    },

    async checkProfile(profile) {
      this.closeLocalTrack(this.sendStream);
      this.sendStream = await AgoraRtc.createCameraVideoTrack({
        encoderConfig: profile.resolution
      });
      this.sendStream.play("test-send");
      await this.wait(1000);
      let videoElement = document.querySelector("#test-send video");
      let settings = this.sendStream.getMediaStreamTrack().getSettings();
      let actualWidth = videoElement && videoElement.videoWidth ? videoElement.videoWidth : settings.width;
      let actualHeight = videoElement && videoElement.videoHeight ? videoElement.videoHeight : settings.height;
      let videoArea = actualWidth * actualHeight;
      let profileArea = profile.width * profile.height;
      if (videoArea === profileArea) {
        profile.status = "resolve";
        return;
      }
      profile.status = "reject";
      throw new Error("Resolution mismatched");
    },

    wait(ms) {
      return new Promise(resolve => setTimeout(resolve, ms));
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
      this.connectivityFinished = false
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
      setTimeout(() => {
        testSuite.notError = AgoraRtc.checkSystemRequirements();
        testSuite.notError
          ? (testSuite.extra = this.t("fully_supported"))
          : (testSuite.extra = this.t("some_functions_may_be_limited"));
        this.handleMicrophoneCheck();
      }, 3000);
    },

    async handleMicrophoneCheck() {
      this.currentTestSuite = "1";
      let testSuite = this.testSuites["1"];
      try {
        this.sendStream = await AgoraRtc.createMicrophoneAudioTrack();
        let totalVolume = 0;
        this.microphoneCheckTimer = setInterval(() => {
          this.inputVolume = Math.floor(
            this.sendStream.getVolumeLevel() * 100
          );
          totalVolume += this.inputVolume;
        }, 100);
        await this.wait(7000);
        clearInterval(this.microphoneCheckTimer);
        this.closeLocalTrack(this.sendStream);
        this.sendStream = null;
        if (totalVolume < 60) {
          testSuite.notError = false;
          testSuite.extra = this.t("can_barely_hear_you");
        } else {
          testSuite.extra = this.t("microphone_works_well");
        }
      } catch (err) {
        testSuite.notError = false;
        testSuite.extra = this.errorMessage(err);
        this.closeLocalTrack(this.sendStream);
        this.sendStream = null;
      } finally {
        this.handleSpeakerCheck();
      }
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

    toggleProxyMode(val) {
      this.fixProxyPort = val;
    },

    async handleCameraCheck() {
      this.currentTestSuite = "3";
      let testSuite = this.testSuites["3"];
      for (let item of this.profiles) {
        await this.checkProfile(item)
          .then(() => {
            this.closeLocalTrack(this.sendStream);
            this.sendStream = null;
          })
          .catch(err => {
            if (err.message === "Resolution mismatched") {
              testSuite.notError = false;
              testSuite.extra = err.message;
            }
            this.closeLocalTrack(this.sendStream);
            this.sendStream = null;
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
      this.connectivityFinished = false;
      // init client and stream
      try {
        await this.initRecvClient();
        await this.initSendClient();
        this.renderChart = true;
      } catch (err) {
        testSuite.extra = this.errorMessage(err);
        testSuite.notError = false;
        setTimeout(() => {
          this.testing = false;
          this.currentTestSuite = "5";
          this.snackbar = true;
        }, 1500);
        return false;
      }
      // go on
      setTimeout(() => {
        this.connectivityFinished = true;
        this.destructAll();
        setTimeout(() => {
          this.testing = false;
          this.currentTestSuite = "5";
          this.snackbar = true;
          if (!this.bitrateData.rows || !this.packetsData.rows) {
            return;
          }
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
      }, 21500);
    },

    haveATry() {
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
      this.retry(0);
    },

    retry(currentIndex) {
      this.closeLocalTrack(this.sendStream);
      this.sendStream = null;
      //If the resolution is equal to not supported, 1. Do not play video stream; 2. Give error prompt
      if (this.ProfileForTry[currentIndex].isSuccess) {
        this.showVideo = true
      } else {
        this.showVideo = false
        return
      }
      AgoraRtc.createCameraVideoTrack({
        encoderConfig: this.ProfileForTry[currentIndex].resolution
      })
        .then(track => {
          this.sendStream = track;
          this.sendStream.play("modal-video");
        })
        .catch(err => {
          this.errMsgForTry = this.errorMessage(err);
        });
    },

    endTry() {
      this.dialog = false;
      this.closeLocalTrack(this.sendStream);
      this.sendStream = null;
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
  height: 240px;
  margin: 0 auto;
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
    padding: 0 16px;
    width: 100%;
  }
  .v-card {
    min-width: 280px;
  }
</style>
