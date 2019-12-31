//
//  ViewController.swift
//  mkvQLT
//
//  Created by Zhia Yang on 30/12/19.
//  Copyright © 2019 Zhia Yang. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

	static var shared: ViewController?

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		ViewController.shared = self
	}

	override var representedObject: Any? {
		didSet {
			// Update the view, if already loaded.
		}
	}


	@IBOutlet weak var image: NSImageView!


	@IBAction func clickity(_ sender: NSButton) {
		doStuff()
	}
}

