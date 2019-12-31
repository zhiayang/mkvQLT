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

	var selectedFile: URL? = nil

	var success: Bool = false {
		didSet {
			if success	{ self.statusText.stringValue = "success" }
			else 		{ self.statusText.stringValue = "failure" }
		}
	}

	override func viewDidLoad()
	{
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		ViewController.shared = self
	}

	override var representedObject: Any?
	{
		didSet {
			// Update the view, if already loaded.
		}
	}

	@IBOutlet weak var statusText: NSTextField!
	
	@IBOutlet weak var image: NSImageView!

	@IBAction func chooseFile_clicked(_ sender: Any)
	{
		let panel = NSOpenPanel()
		panel.allowsMultipleSelection 	= false
		panel.canChooseDirectories 		= false
		panel.canChooseFiles			= true

		panel.begin(completionHandler: { (response) in
			self.selectedFile = panel.url
		})
	}

	@IBAction func generateTestThumbnail_clicked(_ sender: NSButton)
	{
		self.statusText.stringValue = "processing..."
		if let url = self.selectedFile
		{
			doStuff(url: url)
		}
	}
}

