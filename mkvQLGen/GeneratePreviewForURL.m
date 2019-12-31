//
//  GeneratePreviewForURL.m
//  mkvQLGen
//
//  Created by Zhia Yang on 31/12/19.
//  Copyright © 2019 Zhia Yang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuickLook/QuickLook.h>
#import <Foundation/Foundation.h>

OSStatus GeneratePreviewForURL(void* thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options)
{
	return kQLReturnNoError;
}

void CancelPreviewGeneration(void* thisInterface, QLPreviewRequestRef preview)
{
}
