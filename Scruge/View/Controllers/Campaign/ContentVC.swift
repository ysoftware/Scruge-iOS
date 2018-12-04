//
//  CampaignHTMLVC.swift
//  Scruge
//
//  Created by ysoftware on 01/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class ContentViewController: UIViewController {

	@IBOutlet weak var webView: UIWebView!

	var campaignVM:CampaignVM?
	var updateVM:UpdateVM?

	override func viewDidLoad() {
		super.viewDidLoad()
		preferSmallNavbar()

		if let vm = campaignVM?.lastUpdateVM {
			vm.loadDescription { body in
				self.webView.loadHTMLString(body, baseURL: nil)
			}
		}
		else if let vm = updateVM {
			vm.loadDescription { body in
				self.webView.loadHTMLString(body, baseURL: nil)
			}

			let button = UIBarButtonItem(title: "Comments",
										 style: .plain,
										 target: self,
										 action: #selector(openComments))
			navigationItem.rightBarButtonItem = button
		}
	}

	@objc func openComments(_ sender:Any) {
		Service.presenter.presentCommentsViewController(in: self, for: updateVM!)
	}
}
