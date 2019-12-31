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

public func doStuff(url: URL)
{
	let qlg = QLThumbnailGenerator.shared
	let req = QLThumbnailGenerator.Request(fileAt: url, size: CGSize(width: 256, height: 256), scale: 2,
										   representationTypes: .thumbnail)
	req.iconMode = false
	qlg.generateBestRepresentation(for: req, completion: { (rep, err) in

		NSLog("[qlthumbnailext] generating...")
		if let img = rep?.nsImage
		{
			img.size = NSSize(width: 200, height: 300)

			DispatchQueue.main.sync {
				ViewController.shared?.image.image = img
				ViewController.shared?.success = true
			}
		}
		else
		{
			DispatchQueue.main.sync {
				ViewController.shared?.success = false
			}
		}
	})
}
