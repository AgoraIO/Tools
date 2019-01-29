#pragma once

#include <cstdint>
#include <deque>
#include <memory>
#include <mutex>
#include <queue>
#include <string>
#include <unordered_map>
#include <vector>
#include <fstream>
#include <atomic>

#include "AgoraBase.h"
#include "IAgoraRtcEngine.h"
#include "IAgoraMediaEngine.h"
#include "IAgoraService.h"
#include "json_parser.h"

namespace agora {
namespace pstn {

class golem : private rtc::IRtcEngineEventHandler,
              private media::IAudioFrameObserver,
              private media::IVideoFrameObserver {
 public:
  golem(settings_t settings);
  virtual ~golem();
  int run();
  
 private:
  int run_interactive();

 private:
  virtual void onJoinChannelSuccess(const char *cid, uid_t uid, int elapsed);
  virtual void onRejoinChannelSuccess(const char *cid, uid_t uid, int elapsed);
  virtual void onWarning(int warn, const char *msg);
  virtual void onError(int err, const char *msg);
  virtual void onUserJoined(uid_t uid, int elapsed);
  virtual void onUserOffline(uid_t uid, rtc::USER_OFFLINE_REASON_TYPE reason);
  virtual void onRtcStats(const rtc::RtcStats &stats);

  // inherited from IRtcEngineEventHandlerEx
  virtual void onLogEvent(int level, const char *msg, int length);

  // inherited from IAudioFrameObserver
  virtual bool onRecordAudioFrame(AudioFrame& audioFrame);
  virtual bool onPlaybackAudioFrame(AudioFrame& audioFrame);
  virtual bool onMixedAudioFrame(AudioFrame& audioFrame);
  virtual bool onPlaybackAudioFrameBeforeMixing(unsigned int uid, AudioFrame& audioFrame);

  // inherited from IVideoFrameObserver
  virtual bool onCaptureVideoFrame(VideoFrame& videoFrame);
  virtual bool onRenderVideoFrame(unsigned int uid, VideoFrame& videoFrame);

 private:
  void cleanup();
  static void term_handler(int sig_no);
  
 private:
  settings_t settings_;
  bool live_;
  uint32_t uid_;
  std::string vendor_key_;
  std::string channel_name_;
  bool dual_;
  std::string path_;
  int channel_idle_;

  static std::atomic<bool> term_sig;
  std::atomic<bool> joined_;
  int32_t last_active_ts_;
  unsigned int max_users_;

  rtc::IRtcEngine *rtc_engine;
  rtc::RtcEngineParameters *rtc_parameters;
  
  static const unsigned char kBytesPerSample = 2;
  static const unsigned char kChannels = 1;
  
 private:
  golem(const golem &) = delete;
  golem(golem &&) = delete;
  golem& operator=(const golem &) = delete;
  golem& operator=(golem &&) = delete;
  void dump_settings();

  //for input/output file
  std::fstream fs_video;
  std::fstream fs_audio;
};

}
}

