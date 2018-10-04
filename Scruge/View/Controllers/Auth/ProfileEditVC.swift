//
//  ProfileEditVC.swift
//  Scruge
//
//  Created by ysoftware on 04/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class ProfileEditViewController: UIViewController {

	// MARK: - Actions

	@IBAction func save(_ sender: Any) {
		// save
		dismiss(animated: true)
	}

	@objc func cancel(_ sender: Any) {
		ask(question: "Are you sure that you want to quit?") { reply in
			if reply {
				Service.tokenManager.removeToken()
				self.navigationController?.popViewController(animated: true)
			}
		}
	}

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		setupNavigationBarButtons()
	}

	private func setupNavigationBarButtons() {
		navigationItem.setHidesBackButton(true, animated: false)
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
															style: .plain,
															target: self,
															action: #selector(cancel))
	}
}
