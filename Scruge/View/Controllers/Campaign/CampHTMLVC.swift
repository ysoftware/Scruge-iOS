//
//  CampaignHTMLVC.swift
//  Scruge
//
//  Created by ysoftware on 01/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class CampaignHTMLViewController: UIViewController {

	@IBOutlet weak var webView: UIWebView!

	var vm:CampaignVM!

	override func viewDidLoad() {
		super.viewDidLoad()

		vm.loadDescription { body in
			self.webView.loadHTMLString(body, baseURL: nil)
		}
	}
}
