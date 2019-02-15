//
//  ProjectVC.swift
//  Scruge
//
//  Created by ysoftware on 15/02/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import UIKit

final class ProjectViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var loadingView: LoadingView!
	@IBOutlet weak var scrollView: UIScrollView!

	// MARK: - Properties

	var vm:ProjectVM!

	private let NAVBAR_LIMIT:CGFloat = 240

	var offset:CGFloat = 0 {
		didSet {
			setNeedsStatusBarAppearanceUpdate()
			if offset > NAVBAR_LIMIT {
				preferSmallNavbar()
				makeNavbarNormal(with: vm.name)
			}
			else {
				preferSmallNavbar()
				makeNavbarTransparent()
			}
		}
	}

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		localize()
		setupViews()
		setupVM()
		setupActions()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
//
//		if vm.state == .ready {
//			setupBottomButton()
//		}

//		vm.delegate = self
//		reloadData()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if offset < NAVBAR_LIMIT {
			preferSmallNavbar()
			makeNavbarTransparent()
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		makeNavbarNormal()
	}

	private func setupVM() {
//		vm.delegate = self
	}

	private func setupViews() {
		// make table view go under the navigation bar
		if #available(iOS 11.0, *) {
			scrollView.contentInsetAdjustmentBehavior = .never
		}
		automaticallyAdjustsScrollViewInsets = false
	}

	private func setupActions() {

	}

	// MARK: - Actions


	// MARK: - Methods

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return offset > NAVBAR_LIMIT ? .default : .lightContent
	}
}

extension ProjectViewController: UIScrollViewDelegate {

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		offset = scrollView.contentOffset.y
	}
}
