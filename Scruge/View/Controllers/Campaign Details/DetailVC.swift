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
		setup()
	}

	func setup() {
		if let faq = faq {
			title = "Frequently answered question"
			titleLabel.text = faq.question
			contentLabel.text = faq.answer
		}
		else if let milestone = milestone {
			title = "Milestone"
			titleLabel.text = "\(milestone.date)\n\(milestone.fundsRelease)"
			contentLabel.text = milestone.description
		}
	}
}
