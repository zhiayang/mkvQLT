//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#include <stddef.h>
#include <stdint.h>
#include <libavutil/log.h>
#include <libavutil/timestamp.h>
#include <libavformat/avformat.h>

#include "libav-wrapper.h"

unsigned long long get_badge(const void* request);
