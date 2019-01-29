#pragma once

#include <cstdint>

namespace agora {
namespace base {
int64_t now_us();
int64_t now_ms();
int32_t now_seconds();
int32_t now_ts();

int64_t tick_us();
int64_t tick_ms();
int32_t tick_seconds();
}
}
