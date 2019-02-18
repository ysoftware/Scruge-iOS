//
//  BountyVC.swift
//  Scruge
//
//  Created by ysoftware on 18/02/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import UIKit

final class BountyViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var projectNameLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var detailsLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!

	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var rewardsLabel: UILabel!
	@IBOutlet weak var rulesLabel: UILabel!
	@IBOutlet weak var submitButton: Button!
	@IBOutlet weak var buttonView: UIView!

	// MARK: - Properties

	var vm:BountyVM!
	var projectVM:ProjectVM!

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		localize()
		setupViews()
		setupActions()
	}

	private func setupViews() {
		showContributeButton(true)

		// make table view go under the navigation bar
		if #available(iOS 11.0, *) {
			scrollView.contentInsetAdjustmentBehavior = .never
		}
		automaticallyAdjustsScrollViewInsets = false

		projectNameLabel.text = projectVM.name.uppercased()
		dateLabel.text = vm.date
		rewardsLabel.text = vm.rewards
		descriptionLabel.text = vm.description
		rulesLabel.text = vm.rules
	}

	private func showContributeButton(_ visible:Bool = true) {
		let inset = buttonView.frame.height + 20
		let value = visible ? inset : 0

		if #available(iOS 11.0, *) {
			scrollView.contentInset.bottom = value
			scrollView.scrollIndicatorInsets.bottom = value
		}

		buttonView.isHidden = !visible
		buttonView.isHidden = !visible
	}


	private func setupActions() {
		submitButton.addClick(self, action: #selector(submit))
	}

	// MARK: - Actions

	@objc func submit(_ sender:Any) {
		Service.presenter.presentSubmitViewController(in: self, bountyVM: vm)
	}

	// MARK: - Methods


}

