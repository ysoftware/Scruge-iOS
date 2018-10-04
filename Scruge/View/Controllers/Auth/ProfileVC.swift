//
//  ProfileVC.swift
//  Scruge
//
//  Created by ysoftware on 04/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import MVVM

final class ProfileViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var profileImage:UIImageView!
	@IBOutlet weak var nameLabel:UILabel!
	@IBOutlet weak var emailLabel:UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!

	// MARK: - Actions

	@objc func signOut(_ sender:Any) {
		Service.tokenManager.removeToken()
		tabBarController?.selectedIndex = 0
	}

	@IBAction func openSettings(_ sender:Any) {

	}

	// MARK: - Properties

	private var vm = ProfileVM()

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()
		setupVM()
	}

	private func setupVM() {
		vm.delegate = self
		vm.load()
	}

	// MARK: - Methods

	private func refreshProfile() {
		profileImage.kf.setImage(with: vm.imageUrl,
								 placeholder: nil,
								 options: nil,
								 progressBlock: nil) { (image, _, _, _) in
										self.profileImage.isHidden = image == nil
		}
		nameLabel.text = vm.name
		emailLabel.text = vm.email
		descriptionLabel.text = vm.description
		setupNavigationBarButtons()
	}

	private func setupNavigationBarButtons() {
		if Service.tokenManager.getToken() == nil {
			navigationItem.leftBarButtonItem = nil
		}
		else {
			navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out",
															   style: .plain,
															   target: self,
															   action: #selector(signOut))
		}
	}
}

extension ProfileViewController: ViewModelDelegate {

	func didUpdateData<M>(_ viewModel: ViewModel<M>) where M : Equatable {
		refreshProfile()
	}
}
