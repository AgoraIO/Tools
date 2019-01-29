#include "base/time_util.h"

#include <sys/time.h>
#include <time.h>

namespace agora {
namespace base {

int64_t now_us() {
  timeval t = {0, 0};
  ::gettimeofday(&t, NULL);
  return t.tv_sec * 1000ll * 1000 + t.tv_usec;
}

int64_t now_ms() {
  return now_us() / 1000;
}

int32_t now_ts() {
  return static_cast<int32_t>(now_ms() / 1000);
}

int32_t now_seconds() {
  return now_ts();
}

int64_t tick_us() {
  timespec spec = {0, 0};
  clock_gettime(CLOCK_MONOTONIC, &spec);
  return spec.tv_sec * 1000ll * 1000 + (spec.tv_nsec / 1000ll);
}

int64_t tick_ms() {
  return tick_us() / 1000;
}

int32_t tick_seconds() {
  return static_cast<int32_t>(tick_ms() / 1000);
}

}
}
