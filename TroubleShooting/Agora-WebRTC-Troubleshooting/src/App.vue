<template>
  <v-app>
    <!-- title bar -->
    <v-toolbar dark color="primary">
      <v-toolbar-title>Agora WebRTC Precall Test</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn disabled flat icon>
        <v-icon>build</v-icon>
      </v-btn>
      <v-btn v-if="!testing" color="success" @click.native="start">
        Start
      </v-btn>
      <v-btn v-else color="error" disabled>
        Running
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
                  Follow the steps below to check if everything works for Agora Web Real Time Communication!
                </div>
              </v-card-title>
              <v-card-text>
                <v-list>
                  <v-list-tile v-for="item in testSuites" :key="item.id">
                    <v-list-tile-content>
                      <v-list-tile-title>{{item.label}}</v-list-tile-title>
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
                  Test Report
                </v-toolbar-title>
              </v-toolbar>
              <v-list>
                <v-list-group v-for="item in testSuites" :key="item.id">
                  <v-list-tile slot="activator">
                    <v-icon v-if="item.notError" color="success">done</v-icon>
                    <v-icon v-else color="error">close</v-icon>
                    <span> {{item.label}}</span>
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
                <v-stepper-step
                  v-for="item in testSuites"
                  :key="item.id" :step="item.id"
                  :complete="item.complete || (currentTestSuite > item.id)"
                  :rules="[() => item.notError]">
                  {{item.label}}
                  <small v-if="!item.notError">{{item.extra}}</small>
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
                              Browser Check
                            </div>
                          </v-card-title>
                          <v-card-text>
                            In this step, we will check if the browser is supported by Agora Web SDK.
                          </v-card-text>
                        </v-card>
                      </v-flex>
                      <v-flex md6 xs12>
                        <v-card style="height: 100%">
                          <v-card-title>
                            Checking {{browserInfo}}
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
                              Microphone Check
                            </div>
                          </v-card-title>
                          <v-card-text>
                            In this step, we will check if your mic works properly.
                          </v-card-text>
                        </v-card>
                      </v-flex>
                      <v-flex md6 xs12>
                        <v-card style="height: 100%">
                          <v-card-title>
                            Say something to your microphone and see if the progress bar below changes.
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
                            <div class="headline">Speaker Check</div>
                          </v-card-title>
                          <v-card-text>
                            Play the sample music on the right, and see if you can hear it.
                          </v-card-text>
                          <v-card-actions>
                            <v-btn @click="resolveCheck">Yes</v-btn>
                            <v-btn flat @click="rejectCheck">No</v-btn>
                          </v-card-actions>
                        </v-card>
                      </v-flex>

                      <v-flex md6 xs12>
                        <v-card style="height: 100%">
                          <v-card-title>
                            <div class="headline">Sample Music</div>
                          </v-card-title>
                          <v-card-text>
                            <audio id="sampleMusic" controls="controls">
                              <source src="./assets/music.mp3" type="audio/mp3">
                              Your browser does not support the audio tag.
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
                            <div class="headline">Resolution Check</div>
                          </v-card-title>
                          <v-card-text>
                            We will check if video of typical resolutions displays properly.
                          </v-card-text>
                        </v-card>
                      </v-flex>

                      <v-flex md6 xs12>
                        <v-card style="height: 100%">
                          <v-card-title>
                            Resolutions
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
                            <div>We will build a receiver and a sender to check the network connection.</div>
                          </v-card-title>
                          <v-card-text v-if="renderChart">
                            <v-layout row wrap>
                              <v-flex md6 xs12>
                                <linechart :grid="grid" :data="bitrateArray" :settings="bitrateChartSettings"></linechart>
                              </v-flex>
                              <v-flex md6 xs12>
                                <linechart :grid="grid" :data="packetsArray" :settings="packetsChartSettings"></linechart>
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
            Seeing is believing, let us open the camera and have a look?
            <v-btn
              dark
              flat
              @click="haveATry"
            >
              Yes
            </v-btn>
            <v-btn
              dark
              flat
              @click="snackbar = false"
            >
              No
            </v-btn>
          </v-snackbar>
          <!-- dialog -->
          <v-dialog v-model="dialog" persistent max-width="360">
            <v-card>
              <v-card-title>
                <v-tabs v-model="currentProfile">
                  <v-tab
                    v-for="(item, index) in ProfileForTry"
                    @click="retry"
                    :disabled="trying"
                    :key="index"
                  >
                    {{item}}
                  </v-tab>
                </v-tabs>
              </v-card-title>
              <v-card-text>
                <div id="modal-video" v-if="!errMsgForTry">

                </div>
                <div v-else>{{errMsgForTry}}</div>
              </v-card-text>
              <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn color="green darken-1" flat @click.native="endTry">Close</v-btn>
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
        <v-card-text style="text-align:right">SDK Version: {{sdkVersion}}</v-card-text>
      </v-card>
    </v-footer>
  </v-app>
</template>

<script>
import AgoraRtc from "agora-rtc-sdk";
import { profileArray, APP_ID } from "./utils/settings";
export default {
  name: "App",
  components: {
    linechart: () => import("./components/linechart.vue")
  },
  data() {
    this.bitrateChartSettings = {
      yAxisName: ["bitrate (kbps)"]
    };
    this.packetsChartSettings = {
      yAxisType: ["percent"],
      yAxisName: ["packet loss"]
    };
    this.grid = {
      left: 50
    };
    this.browserInfo = navigator.appVersion || "Current Browser";
    return {
      sdkVersion: AgoraRtc.VERSION || '2.4.0',
      trying: false,
      snackbar: false,
      dialog: false,
      currentTestSuite: "-1",
      inputVolume: 0,
      renderChart: false,
      testing: false,
      profiles: profileArray.map(item => {
        item.status = "pending";
        return item;
      }),
      testSuites: [
        {
          id: "0",
          label: "Browser Compatibility",
          notError: true,
          extra: ""
        },
        {
          id: "1",
          label: "Microphone",
          notError: true,
          extra: ""
        },
        {
          id: "2",
          label: "Speaker",
          notError: true,
          extra: ""
        },
        {
          id: "3",
          label: "Resolution",
          notError: true,
          extra: ""
        },
        {
          id: "4",
          label: "Connection",
          notError: true,
          extra: ""
        }
      ],
      bitrateArray: {
        columns: ["index", "Video Bitrate", "Audio Bitrate"],
        rows: [{ index: 0, "Video Bitrate": 0, "Audio Bitrate": 0 }]
      },
      packetsArray: {
        columns: ["index", "Video Packet Loss", "Audio Packet Loss"],
        rows: [{ index: 0, "Video Packet Loss": 0, "Audio Packet Loss": 0 }]
      },
      errMsgForTry: "",
      ProfileForTry: ["480p_1", "720p_1", "1080p_1"],
      currentProfile: 0
    };
  },

  methods: {
    initialize() {
      this.ts = new Date().getTime();
      this.channel =
        String(this.ts).slice(7) +
        Math.floor(Math.random() * 1000000).toString(36);
      this.sendId = Number.parseInt(String(this.ts).slice(7), 10) * 10 + 1;
      this.recvId = Number.parseInt(String(this.ts).slice(7), 10) * 10 + 2;
      this.sendClient = AgoraRtc.createClient({ mode: 'live', codec: 'h264' });
      this.recvClient = AgoraRtc.createClient({ mode: 'live', codec: 'h264' });
    },

    initSendClient() {
      return new Promise((resolve, reject) => {
        this.sendStream = AgoraRtc.createStream({
          streamID: this.sendId,
          video: true,
          audio: true,
          screen: false
        });
        this.sendStream.setVideoProfile("720p_2");
        this.sendClient.init(
          APP_ID,
          () => {
            this.sendStream.init(
              () => {
                this.sendClient.join(
                  null,
                  this.channel,
                  this.sendId,
                  () => {
                    this.sendClient.publish(this.sendStream, err => {
                      reject(err);
                    });
                    setTimeout(() => {
                      resolve();
                    });
                  },
                  err => {
                    reject(err);
                  }
                );
              },
              err => {
                reject(err);
              }
            );
          },
          err => {
            reject(err);
          }
        );
      });
    },

    initRecvClient() {
      return new Promise((resolve, reject) => {
        this.recvClient.init(
          APP_ID,
          () => {
            this.recvClient.join(
              null,
              this.channel,
              this.recvId,
              () => {
                this.recvClient.on("stream-added", evt => {
                  this.recvClient.subscribe(evt.stream, err => {
                    clearInterval(this.detectInterval);
                    this.bitrateArray = [];
                    this.packetsArray = [];
                    this.testSuites["4"].notError = false;
                    this.testSuites["4"].extra = err.msg;
                    this.destructAll();
                    this.currentTestSuite = "5";
                  });
                });
                this.recvClient.on("stream-removed", () => {
                  clearInterval(this.detectInterval);
                  this.bitrateArray = [];
                  this.packetsArray = [];
                  this.testSuites["4"].notError = false;
                  this.testSuites["4"].extra = "Disconnected";
                  this.destructAll();
                  this.currentTestSuite = "5";
                });
                this.recvClient.on("stream-subscribed", evt => {
                  this.recvStream = evt.stream;
                  this.recvStream.disableAudio();
                  this.recvStream.play("test-recv");
                  let i = 1;
                  this.detectInterval = setInterval(() => {
                    this.recvStream.getStats(e => {
                      this.bitrateArray.rows.push({
                        index: i,
                        "Video Bitrate": this._calcBitrate(
                          e.videoReceiveBytes, i
                        ),
                        "Audio Bitrate": this._calcBitrate(
                          e.audioReceiveBytes, i
                        )
                      });
                      this.packetsArray.rows.push({
                        index: i,
                        "Video Packet Loss": this._calcPacketLoss(
                          e.videoReceivePackets,
                          e.videoReceivePacketsLost
                        ),
                        "Audio Packet Loss": this._calcPacketLoss(
                          e.audioReceivePackets,
                          e.audioReceivePacketsLost
                        ),
                      });
                      i++;
                    });
                  }, 1000);
                });
                resolve();
              },
              err => {
                reject(err);
              }
            );
          },
          err => {
            reject(err);
          }
        );
      });
    },

    /**
     * @param {string} recvPackets
     * @param {string} recvPacketsLost
     */
    _calcPacketLoss(recvPackets, recvPacketsLost) {
      let recvPacketsNumber = Number(recvPackets);
      let recvPacketsLostNumber = Number(recvPacketsLost);
      return Number.parseFloat(recvPacketsLostNumber/(recvPacketsNumber+recvPacketsLostNumber)).toFixed(4);
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
        this.sendStream && this.sendStream.close();
        this.recvStream && this.recvStream.close();
        this.sendClient.unpublish(this.sendStream);
        this.sendClient.leave();
        this.recvClient.leave();
        clearInterval(this.detectInterval);
      } catch (err) {
        throw(err);
      }
    },

    checkProfile(profile) {
      return new Promise((resolve, reject) => {
        this.sendStream && this.sendStream.stop();
        this.sendStream = AgoraRtc.createStream({
          streamID: this.sendId,
          video: true,
          audio: true,
          screen: false
        });
        this.sendStream.setVideoProfile(profile.enum);
        this.sendStream.init(
          () => {
            this.sendStream.play("test-send");
            setTimeout(() => {
              let videoElement = document.querySelector("#video" + this.sendId);
              if (
                videoElement.videoWidth === profile.width &&
                videoElement.videoHeight === profile.height
              ) {
                profile.status = "resolve";
                resolve();
              } else {
                profile.status = "reject";
                reject("Resolution mismatched");
              }
            }, 1000);
          },
          err => {
            reject(err);
          }
        );
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
      this.handleCompatibilityCheck();
    },

    restore() {
      this.testSuites.map(item => {
        item.notError = true;
        item.extra = "";
        item.complete = false;
      });
      (this.currentTestSuite = "-1"),
        (this.inputVolume = 0),
        (this.renderChart = false),
        (this.testing = false),
        (this.profiles = profileArray.map(item => {
          item.status = "pending";
          return item;
        })),
        (this.bitrateArray = {
          columns: ["index", "Video Bitrate", "Audio Bitrate"],
          rows: [{ index: 0, "Video Bitrate": 0, "Audio Bitrate": 0 }]
        }),
        (this.packetsArray = {
          columns: ["index", "Video Packet Loss", "Audio Packet Loss"],
          rows: [{ index: 0, "Video Packet Loss": 0, "Audio Packet Loss": 0 }]
        });
    },

    handleCompatibilityCheck() {
      this.currentTestSuite = "0";
      let testSuite = this.testSuites["0"];
      setTimeout(() => {
        testSuite.notError = AgoraRtc.checkSystemRequirements();
        testSuite.notError
          ? (testSuite.extra = "Fully supported")
          : (testSuite.extra = "Some functions may be limited");
        this.handleMicrophoneCheck();
      }, 3000);
    },

    handleMicrophoneCheck() {
      this.currentTestSuite = "1";
      let testSuite = this.testSuites["1"];
      this.sendStream = AgoraRtc.createStream({
        streamID: this.sendId,
        video: false,
        audio: true,
        screen: false
      });
      this.sendStream.init(
        () => {
          this.sendStream.play("test-send");
          let totalVolume = 0;
          this.microphoneCheckTimer = setInterval(() => {
            this.inputVolume = Math.floor(
              this.sendStream.getAudioLevel() * 100
            );
            totalVolume += this.inputVolume;
          }, 100);
          setTimeout(() => {
            clearInterval(this.microphoneCheckTimer);
            this.sendStream.close();
            if (totalVolume < 60) {
              testSuite.notError = false;
              testSuite.extra = "Can barely hear you";
            } else {
              testSuite.extra = "Microphone works well";
            }
            this.handleSpeakerCheck();
          }, 7000);
        },
        err => {
          // do next test
          testSuite.notError = false;
          testSuite.extra = err.msg;
          try {
            this.sendStream.close();
          } catch (error) {
            throw(error);
          } finally {
            this.handleSpeakerCheck();
          }
        }
      );
    },

    handleSpeakerCheck() {
      this.currentTestSuite = "2";
    },

    resolveCheck() {
      let testSuite = this.testSuites[this.currentTestSuite];
      testSuite.extra = "Speaker works well";
      let sound = document.querySelector("#sampleMusic");
      sound.pause();
      sound.currentTime = 0;
      this.handleCameraCheck();
    },

    rejectCheck() {
      let testSuite = this.testSuites[this.currentTestSuite];
      testSuite.notError = false;
      testSuite.extra = "Something is wrong with the speaker";
      let sound = document.querySelector("#sampleMusic");
      sound.pause();
      sound.currentTime = 0;
      this.handleCameraCheck();
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
            if (err !== "Resolution mismatched") {
              testSuite.notError = false;
              testSuite.extra = err.msg;
            }
          });
      }

      if (testSuite.notError) {
        let arr = [];
        this.profiles.map(item => {
          let str = `${item.width} * ${item.height} ${
            item.status === "resolve" ? "support" : "not support"
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
        await this.initRecvClient();
        await this.initSendClient();
        this.renderChart = true;
      } catch (err) {
        testSuite.extra = err.msg;
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
        this.destructAll();
        setTimeout(() => {
          this.testing = false;
          this.currentTestSuite = "5";
          this.snackbar = true;
          if (
            this.bitrateArray.rows.length === 1 ||
            this.packetsArray.rows.length === 1
          ) {
            testSuite.extra = "Poor connection";
            testSuite.notError = false;
          }
          if (testSuite.notError) {
            let bitrateInfo = this.bitrateArray.rows.pop();
            let packetInfo = this.packetsArray.rows.pop();
            testSuite.extra = `Video Bitrate: ${
              bitrateInfo["Video Bitrate"]
            } kbps </br>
                              Audio Bitrate: ${
                                bitrateInfo["Audio Bitrate"]
                              } kbps </br>
                              Video Packet Loss: ${
                                packetInfo["Video Packet Loss"]*100
                              } % </br>
                              Audio Packet Loss: ${
                                packetInfo["Audio Packet Loss"]*100
                              } % </br>`;
          }
        }, 1500);
      }, 21500);
    },

    haveATry() {
      this.snackbar = false;
      this.dialog = true;
      this.retry();
    },

    retry() {
      this.trying = true;
      if (this.sendStream) {
        this.sendStream.stop();
        this.sendStream.close();
      }
      this.sendStream = AgoraRtc.createStream({
        streamID: this.sendId,
        video: true,
        audio: true,
        screen: false
      });
      this.sendStream.setVideoProfile(this.ProfileForTry[this.currentProfile]);
      this.sendStream.init(
        () => {
          this.sendStream.play("modal-video");
          this.trying = false;
        },
        err => {
          this.errMsgForTry = err.msg;
          this.trying = false;
        }
      );
    },

    endTry() {
      this.dialog = false;
      this.sendStream.stop();
      this.sendStream.close();
    }
  }
};
</script>

<style>
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
.v-list__tile {
  min-height: 48px!important;
  height: auto!important;
}
</style>
