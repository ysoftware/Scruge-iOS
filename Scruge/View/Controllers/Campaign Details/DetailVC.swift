//
//  DetailVC.swift
//  Scruge
//
//  Created by ysoftware on 05/12/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var contentLabel: UILabel!

	var faq:FaqVM?
	var milestone:MilestoneVM?

	override func viewDidLoad() {
		super.viewDidLoad()

		localize()
		setup()
	}

	func setup() {
		if let faq = faq {
			title = R.string.localizable.title_faq_single()
			titleLabel.text = faq.question
			contentLabel.text = faq.answer
		}
		else if let milestone = milestone {
			title = R.string.localizable.title_milestone_single()
			titleLabel.text = "\(milestone.date)\n\(milestone.fundsRelease)"
			contentLabel.text = milestone.description
		}
	}
}
