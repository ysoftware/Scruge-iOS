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

	@IBOutlet weak var tableView: UITableView!
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

	private var profileVM = ProfileVM()
	private var campaignsVM = CampaignAVM()

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		setupTable()
		setupVM()
	}

	private func setupTable() {
		tableView.estimatedRowHeight = 400
		tableView.rowHeight = UITableView.automaticDimension
		tableView.register(UINib(resource: R.nib.campaignSmallCell),
						   forCellReuseIdentifier: R.reuseIdentifier.campaignCell.identifier)
	}

	private func setupVM() {
		profileVM.delegate = self
		profileVM.load()

		campaignsVM.delegate = self
		campaignsVM.reloadData()
	}

	// MARK: - Methods

	private func refreshProfile() {
		profileImage.kf.setImage(with: profileVM.imageUrl,
								 placeholder: nil,
								 options: nil,
								 progressBlock: nil) { (image, _, _, _) in
										self.profileImage.isHidden = image == nil
		}
		nameLabel.text = profileVM.name
		emailLabel.text = profileVM.email
		descriptionLabel.text = profileVM.description
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

extension ProfileViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return campaignsVM.numberOfItems
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.campaignCell,
											 for: indexPath)!
		.setup(with: campaignsVM.item(at: indexPath.row))
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Backed by you"
	}
}

extension ProfileViewController: ViewModelDelegate {

	func didUpdateData<M>(_ viewModel: ViewModel<M>) where M : Equatable {
		refreshProfile()
	}
}

extension ProfileViewController: ArrayViewModelDelegate {

	func didChangeState(to state: ArrayViewModelState) {

	}

	func didUpdateData<M, VM, Q>(_ arrayViewModel: ArrayViewModel<M, VM, Q>, _ update: MVVM.Update)
		where M : Equatable, VM : ViewModel<M>, Q : Query {
		tableView.reloadData()
	}
}
