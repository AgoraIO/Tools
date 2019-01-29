#pragma once

#include <sys/types.h>
#include <unistd.h>

#include <cinttypes>
#include <cstdint>
#include <cstdlib>
#include <stdarg.h>
#include <cassert>
#include <syslog.h>

namespace agora { namespace base {

    enum log_levels
    {
        DEBUG_LOG  = LOG_DEBUG,    /* 7 debug-level messages */
        INFO_LOG  = LOG_INFO,     /* 6 informational */
        NOTICE_LOG  = LOG_NOTICE,   /* 5 normal but significant condition */
        WARN_LOG  = LOG_WARNING,  /* 4 warning conditions */
        ERROR_LOG  = LOG_ERR,      /* 3 error conditions */
        FATAL_LOG  = LOG_CRIT,     /* 2 critical conditions */
    };
    struct log_config
    {
        static int enabled_level;
        static uint64_t dropped_count;

        static uint32_t drop_cancel;
        const static uint32_t DROP_COUNT = 1000;

        static inline void enable_debug(bool enabled)
        {
            if (enabled) {
                log_config::enabled_level = DEBUG_LOG;
            } else {
                log_config::enabled_level = INFO_LOG;
            }
        }

        static bool set_drop_cannel(uint32_t cancel)
        {
            if (cancel > DROP_COUNT) {
                drop_cancel = DROP_COUNT;
                return false;
            }

            drop_cancel = cancel;
            return true;
        }

        static inline bool log_enabled(log_levels level)
        {
            if (level <= enabled_level) {
                return true;
            }

            ++dropped_count;
            return (dropped_count % DROP_COUNT < drop_cancel);
        }
    };

    inline void open_log()
    {
        ::openlog(NULL, LOG_PID|LOG_NDELAY, LOG_USER|LOG_DAEMON);
    }

    inline void log(log_levels level, const char* format, ...)
    {
        if (! log_config::log_enabled(level)) {
            return;
        }
        va_list args;
        va_start(args, format);
        ::vsyslog(level, format, args);
        va_end(args);
    }
    inline void close_log()
    {
        ::closelog();
    }
}} // namespace agora::base

#define LOG(level, fmt, ...) log(agora::base::level ## _LOG, \
    "(%d) %s:%d: " fmt, getpid(), __FILE__, __LINE__, ##__VA_ARGS__)

#define LOG_IF(level, cond, ...) \
  if (cond) { \
    LOG(level,  __VA_ARGS__); \
  }

#define LOG_EVERY_N(level, N, ...) \
  {  \
    static unsigned int count = 0; \
    if (++count % N == 0) \
      LOG(level, __VA_ARGS__); \
  }

#define DCHECK(cond) assert(cond)
