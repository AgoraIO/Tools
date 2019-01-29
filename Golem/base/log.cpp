#include "log.h"

using namespace agora::base;

int log_config::enabled_level = INFO_LOG;
uint64_t log_config::dropped_count = 0;
uint32_t log_config::drop_cancel = 10;
