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

	private let NAVBAR_LIMIT:CGFloat = 240

	var offset:CGFloat = 0 {
		didSet {
			setNeedsStatusBarAppearanceUpdate()
			if offset > NAVBAR_LIMIT {
				preferSmallNavbar()
				makeNavbarNormal(with: "\(projectVM.name): \(vm.name)")
			}
			else {
				preferSmallNavbar()
				makeNavbarTransparent()
			}
		}
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		localize()
		setupViews()
		setupActions()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		makeNavbarTransparent()
		preferLargeNavbar()
		navBarTitleColor(.white)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		makeNavbarNormal()
		navBarTitleColor()
	}

	private func setupViews() {
		showContributeButton(true)

		projectNameLabel.text = projectVM.name.uppercased()
		nameLabel.text = vm.name
		dateLabel.text = vm.dates
		rewardsLabel.text = vm.rewards
		descriptionLabel.text = vm.description
		rulesLabel.text = vm.rules
		detailsLabel.attributedText = vm.longerDescription
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
		Service.presenter.presentSubmitViewController(in: self, bountyVM: vm, projectVM: projectVM)
	}
}

extension BountyViewController: UIScrollViewDelegate {

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		offset = scrollView.contentOffset.y
	}
}
