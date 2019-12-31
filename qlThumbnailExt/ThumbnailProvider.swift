//
//  ThumbnailProvider.swift
//  qlThumbnailExt
//
//  Created by Zhia Yang on 27/12/19.
//  Copyright © 2019 Zhia Yang. All rights reserved.
//

import os.log

import AppKit
import QuickLookThumbnailing

class ThumbnailProvider: QLThumbnailProvider
{
	let logger = OSLog(subsystem: "com.zhiayang.qlThumbnailExt", category: "some_category")

	override func provideThumbnail(for request: QLFileThumbnailRequest, _ handler: @escaping (QLThumbnailReply?, Error?) -> Void)
	{
		os_log("request is %fx%f for '%@'", log: logger, type: .error,
			   request.maximumSize.width, request.maximumSize.height, request.fileURL.path)

		if let (image, art) = getCoverArt(for: request.fileURL.path)
		{
			let maximumSize = request.maximumSize

			let imageSize = CGSize(width: image.width, height: image.height)

			// calculate `newImageSize` and `contextSize` such that the image fits perfectly and respects the constraints
			var newImageSize = maximumSize
			var contextSize = maximumSize
			let aspectRatio = imageSize.height / imageSize.width
			let proposedHeight = aspectRatio * maximumSize.width

			if proposedHeight <= maximumSize.height
			{
				newImageSize.height = proposedHeight
				contextSize.height = max(proposedHeight.rounded(.down), request.minimumSize.height)
			}
			else
			{
				newImageSize.width = maximumSize.height / aspectRatio
				contextSize.width = max(newImageSize.width.rounded(.down), request.minimumSize.width)
			}

			newImageSize.width *= request.scale
			newImageSize.height *= request.scale

			os_log("ctx: %fx%f, img: %fx%f", log: logger, type: .error,
				   contextSize.width, contextSize.height, newImageSize.width, newImageSize.height)

			let reply = QLThumbnailReply(contextSize: contextSize, drawing: { (context) -> Bool in
				return self.draw(image: image, in: context, ctxSize: contextSize, imgSize: newImageSize,
								 fp: request.fileURL.path, freeing: art)
			})

//			let _ = get_badge(UnsafeMutableRawPointer(Unmanaged.passUnretained(reply).toOpaque()))

//			var str: String = ""
//			dump(reply, to: &str)
//			os_log("    * contents: %@", log: logger, type: .error, str)
			handler(reply, nil)
		}
		else
		{
			handler(nil, nil)
		}
    }


	private func draw(image: CGImage, in context: CGContext, ctxSize: CGSize, imgSize: CGSize, fp: String,
					  freeing art: CoverArt) -> Bool
	{
//		context.setFillColor(CGColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1),
//									 blue: CGFloat.random(in: 0...1), alpha: 1.0))
//		context.fill(CGRect(origin: .zero, size: CGSize(width: context.width, height: context.height)))
		context.draw(image, in: CGRect(origin: .zero, size: imgSize))
		
		os_log("successfully drew cover art for file %@!", log: logger, type: .error, fp)

		freeCoverArt(art)

		return true
	}

	private func getCoverArt(for filepath: String) -> (CGImage, CoverArt)?
	{
		let cover = getAttachedCoverArt(filepath)

		if let data = cover.data
		{
			let dataProvider = CGDataProvider(dataInfo: nil, data: data, size: cover.size, releaseData: { _, _, _ in  })

			if let dp = dataProvider
			{
				if cover.isPng != 0
				{
					return (CGImage(pngDataProviderSource: dp, decode: nil, shouldInterpolate: false,
									intent: .defaultIntent)!, cover)
				}
				else
				{
					return (CGImage(jpegDataProviderSource: dp, decode: nil, shouldInterpolate: false,
									intent: .defaultIntent)!, cover)
				}
			}
		}

		return nil
	}
}
