//
//  GenerateThumbnailForURL.m
//  mkvQLGen
//
//  Created by Zhia Yang on 31/12/19.
//  Copyright © 2019 Zhia Yang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuickLook/QuickLook.h>
#import <Foundation/Foundation.h>

#include "libav-wrapper.h"

// https://github.com/Marginal/QLVideo/blob/master/qlgenerator/GenerateThumbnailForURL.m
// https://github.com/shysaur/QLWindowsApps/commit/52f1e070a3fd09371b5194487f1413585b280d02#comments
const CFStringRef kQLThumbnailPropertyIconFlavorKey_10_5 = CFSTR("IconFlavor");
const CFStringRef kQLThumbnailPropertyIconFlavorKey_10_15 = CFSTR("icon");

typedef NS_ENUM(NSInteger, QLThumbnailIconFlavor)
{
	kQLThumbnailIconPlainFlavor		= 0,
	kQLThumbnailIconShadowFlavor	= 1,
	kQLThumbnailIconBookFlavor		= 2,
	kQLThumbnailIconMovieFlavor		= 3,
	kQLThumbnailIconAddressFlavor	= 4,
	kQLThumbnailIconImageFlavor		= 5,
	kQLThumbnailIconGlossFlavor		= 6,
	kQLThumbnailIconSlideFlavor		= 7,
	kQLThumbnailIconSquareFlavor	= 8,
	kQLThumbnailIconBorderFlavor	= 9,
	// = 10,
	kQLThumbnailIconCalendarFlavor	= 11,
	kQLThumbnailIconPatternFlavor	= 12,
};


extern "C" OSStatus GenerateThumbnailForURL(void* thisInterface, QLThumbnailRequestRef thumbnail, CFURLRef _url, CFStringRef contentTypeUTI, CFDictionaryRef options, CGSize maxSize)
{
	@autoreleasepool {
		auto url = (__bridge NSURL*) _url;
		auto path = [url path];

		NSLog(@"[qlthumbnail]: generating thumbnail for path: %@", path);

		auto ca = getAttachedCoverArt([path UTF8String]);
		if(!ca.data || !ca.size)
			return kQLReturnNoError;

		auto cfd = CFDataCreateWithBytesNoCopy(NULL, ca.data, ca.size, kCFAllocatorNull);
		auto cgp = CGDataProviderCreateWithCFData(cfd);

		auto image = ca.isPng
					? CGImageCreateWithPNGDataProvider(cgp, NULL, false, kCGRenderingIntentDefault)
					: CGImageCreateWithJPEGDataProvider(cgp, NULL, false, kCGRenderingIntentDefault);

		CGDataProviderRelease(cgp);
		CFRelease(cfd);

		NSString* flavourKey = NULL;
		if(@available(macOS 10.15, *))
			flavourKey = (__bridge NSString*) kQLThumbnailPropertyIconFlavorKey_10_15;

		else
			flavourKey = (__bridge NSString*) kQLThumbnailPropertyIconFlavorKey_10_5;

		
		auto dict = @{
			flavourKey: @(kQLThumbnailIconGlossFlavor)
		};

		QLThumbnailRequestSetImage(thumbnail, image, (__bridge CFDictionaryRef) dict);
		CGImageRelease(image);

		freeCoverArt(ca);
	}

	return kQLReturnNoError;
}

extern "C" void CancelThumbnailGeneration(void* thisInterface, QLThumbnailRequestRef thumbnail)
{
	// you can't cancel me
}
