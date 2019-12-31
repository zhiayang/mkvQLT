//
//  libav-wrapper.cpp
//  qlThumbnailExt
//
//  Created by Zhia Yang on 29/12/19.
//  Copyright © 2019 Zhia Yang. All rights reserved.
//

#include <string.h>
#include <objc/message.h>

#import <Foundation/Foundation.h>


template <typename T>
struct objcinator { };

template <typename R, typename... Args>
struct objcinator<R (Args...)>
{
	R call(const void* obj, SEL sel, Args&&... xs)
	{
		id target = (__bridge id) obj;

		using wrapper_t = R (*)(id, SEL, Args...);

		auto wrapper = reinterpret_cast<wrapper_t>(objc_msgSend);
		return wrapper(target, sel, xs...);
	}
};


extern "C" {

	#include "qlThumbnailExt-Bridging-Header.h"

	CoverArt getAttachedCoverArt(const char* path)
	{
		CoverArt ret;
		ret.data = 0;
		ret.size = 0;
		ret.width = 0;
		ret.height = 0;
		ret.isPng = false;

		auto ctx = avformat_alloc_context();
		if(avformat_open_input(&ctx, path, nullptr, nullptr) < 0)
		{
			NSLog(@"[com.zhiayang.mkvQLT]: failed to open input file %s", path);
			return ret;
		}

		if(avformat_find_stream_info(ctx, nullptr) < 0)
		{
			NSLog(@"[com.zhiayang.mkvQLT]: failed to read streams %s", path);
			return ret;
		}

		for(unsigned int i = 0; i < ctx->nb_streams; i++)
		{
			auto strm = ctx->streams[i];

			// look for attached pics.
			if(strm->codecpar->codec_type == AVMEDIA_TYPE_VIDEO &&
				strm->disposition & AV_DISPOSITION_ATTACHED_PIC)
			{
				// you are the chosen one
				auto pic = strm->attached_pic;
				ret.size = pic.size;
				ret.width = strm->codecpar->width;
				ret.height = strm->codecpar->height;

				ret.data = new uint8_t[ret.size];
				memcpy(ret.data, pic.data, ret.size);

				if(strm->codecpar->codec_id == AV_CODEC_ID_PNG)
					ret.isPng = true;

				break;
			}
		}

		avformat_close_input(&ctx);
		avformat_free_context(ctx);

		return ret;
	}

	void freeCoverArt(CoverArt art)
	{
		if(art.data == nullptr)
			return;

		delete[] art.data;
	}

	unsigned long long get_badge(const void* obj)
	{
		NSLog(@"[qlthumbnail]: doing dumb shit... (1)");
		objcinator<void (unsigned long long)>().call(obj, @selector(setType:), 0);

		NSLog(@"[qlthumbnail]: doing dumb shit... (2)");
		auto ret = objcinator<unsigned long long ()>().call(obj, @selector(type));
		NSLog(@"[qlthumbnail]: finished: %llu", ret);

		return 30;
//		return objc_msgSend(obj, "badgeType");
	}
}
