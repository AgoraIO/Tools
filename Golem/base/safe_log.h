#pragma once

#include <sys/types.h>
#include <unistd.h>

#include <sstream>

#include "base/log.h"

namespace agora {
namespace base {
class safe_log {
 public:
  safe_log(const char *file, int line, int severity);
  ~safe_log();

  std::ostream& stream();
 private:
  int severity_;
  std::ostringstream sout_;
};

inline safe_log::safe_log(const char *file, int line, int severity) {
  severity_ = severity;
  sout_ << file << ":" << line << ": ";
}

inline safe_log::~safe_log() {
  typedef agora::base::log_levels severity_t;
  severity_t severity = static_cast<severity_t>(severity_);
  log(severity, "(%d) %s", getpid(), sout_.str().c_str());
}

inline std::ostream& safe_log::stream() {
  return sout_;
}

}
}

#define SAFE_LOG(level) agora::base::safe_log(__FILE__, __LINE__, \
    agora::base::log_levels::level ## _LOG).stream()

