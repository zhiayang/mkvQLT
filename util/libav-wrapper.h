//
//  libav-wrapper.h
//  mkvQLT
//
//  Created by Zhia Yang on 31/12/19.
//  Copyright © 2019 Zhia Yang. All rights reserved.
//

#ifndef libav_wrapper_h
#define libav_wrapper_h

#ifdef __cplusplus
extern "C" {
#endif

struct CoverArt
{
	uint8_t* data;
	size_t size;

	int width;
	int height;

	int isPng;
};

struct CoverArt getAttachedCoverArt(const char* path);
void freeCoverArt(struct CoverArt art);

#ifdef __cplusplus
}
#endif

#endif /* libav_wrapper_h */
