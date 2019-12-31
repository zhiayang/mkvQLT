//
//  Stuff.swift
//  mkvQLT
//
//  Created by Zhia Yang on 30/12/19.
//  Copyright © 2019 Zhia Yang. All rights reserved.
//

import Cocoa
import Foundation
import QuickLookThumbnailing

public func doStuff()
{
	print("doing stuff now")

	let qlg = QLThumbnailGenerator.shared
	let req = QLThumbnailGenerator.Request(fileAt: URL(fileURLWithPath: "/Users/zhiayang/Desktop/test.mkv"),
										  size: CGSize(width: 256, height: 256), scale: 1, representationTypes: .thumbnail)
	req.iconMode = false
	qlg.generateBestRepresentation(for: req, completion: { (rep, err) in

		NSLog("[qlthumbnailext] generating...")
		if let img = rep?.nsImage
		{
			print("lmao")
			img.size = NSSize(width: 200, height: 300)

			DispatchQueue.main.sync {
				ViewController.shared?.image.image = img
			}
		}
		else
		{
			print("sadface")
		}
	})
}
