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
	
//	@IBOutlet weak var loadingView: LoadingView!
//	@IBOutlet weak var tableView: UITableView!
//	@IBOutlet weak var profileImage:UIImageView!
//	@IBOutlet weak var nameLabel:UILabel!
//	@IBOutlet weak var emailLabel:UILabel!
//	@IBOutlet weak var descriptionLabel: UILabel!

	// MARK: - Actions

//	@objc func signOut(_ sender:Any) {
//		Service.tokenManager.removeToken()
//		tabBarController?.selectedIndex = 0
//	}
//
//	@IBAction func openWallet(_ sender: Any) {
//		Service.presenter.presentWallerViewController(in: self)
//	}

	@IBAction func openSettings(_ sender:Any) {
		Service.presenter.presentSettingsViewController(in: self)
	}

//	@IBAction func editProfile(_ sender:Any) {
//		Service.presenter.presentProfileEditViewController(in: self, with: profileVM)
//	}

	// MARK: - Properties

	private var profileVM = ProfileVM()
//	private var campaignsVM = CampaignAVM()
//
	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		setupTable()
		setupVM()
	}
//
//	override func viewDidAppear(_ animated: Bool) {
//		super.viewDidAppear(animated)
//
//		profileVM.load()
//
//		switch campaignsVM.state {
//		case .ready, .error:
//			if campaignsVM.numberOfItems == 0 {
//				campaignsVM.reloadData()
//			}
//		default: break
//		}
//	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.makeTransparent()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.navigationBar.makeNormal()
	}


	private func setupTable() {
//		tableView.refreshControl = UIRefreshControl()
//		tableView.refreshControl?.addTarget(self, action: #selector(reloadData), for: .valueChanged)
//
//		tableView.estimatedRowHeight = 400
//		tableView.rowHeight = UITableView.automaticDimension
//		tableView.register(UINib(resource: R.nib.campaignSmallCell),
//						   forCellReuseIdentifier: R.reuseIdentifier.campaignCell.identifier)
	}

	private func setupVM() {
		profileVM.delegate = self

//		campaignsVM.delegate = self
//		campaignsVM.query?.requestType = .backed
//		reloadData()
	}

	// MARK: - Methods

//	@objc func reloadData() {
//		campaignsVM.reloadData()
//	}
//
	private func refreshProfile() {
//		profileImage.setImage(url: profileVM.imageUrl)
//		nameLabel.text = profileVM.name
//		emailLabel.text = profileVM.email
//		descriptionLabel.text = profileVM.description
	}
}

//extension ProfileViewController: UITableViewDelegate {
//
//	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		tableView.deselectRow(at: indexPath, animated: true)
//		Service.presenter.presentCampaignViewController(in: self,
//														id: campaignsVM.item(at: indexPath.row).id)
//	}
//}
//
//extension ProfileViewController: UITableViewDataSource {
//
//	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		return campaignsVM.numberOfItems
//	}
//
//	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.campaignCell,
//											 for: indexPath)!
//		.setup(with: campaignsVM.item(at: indexPath.row))
//	}
//
//	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//		return "Backed by you"
//	}
//}

extension ProfileViewController: ViewModelDelegate {

	func didUpdateData<M>(_ viewModel: ViewModel<M>) where M : Equatable {
		refreshProfile()
	}
}

//extension ProfileViewController: ArrayViewModelDelegate {
//
//	func didChangeState<M, VM, Q>(_ arrayViewModel: ArrayViewModel<M, VM, Q>,
//								  to state: ArrayViewModelState)
//		where M : Equatable, VM : ViewModel<M>, Q : Query {
//
//			switch campaignsVM.state {
//			case .error(let error):
//				tableView.refreshControl?.endRefreshing()
//				let message = ErrorHandler.message(for: error)
//				loadingView.set(state: .error(message))
//
//				if error.isAuthenticationFailureError {
//					Service.presenter.presentLoginViewController(in: self) { didLogIn in
//						if !didLogIn {
//							self.tabBarController?.selectedIndex = 0
//						}
//					}
//				}
//			case .loading, .initial:
//				loadingView.set(state: .loading)
//			case .ready:
//				tableView.refreshControl?.endRefreshing()
//				if campaignsVM.isEmpty {
//					loadingView.set(state: .error("You haven't backed any campaigns yet."))
//				}
//				else {
//					loadingView.set(state: .ready)
//				}
//			default: break
//			}
//	}
//
//	func didUpdateData<M, VM, Q>(_ arrayViewModel: ArrayViewModel<M, VM, Q>, _ update: MVVM.Update)
//		where M : Equatable, VM : ViewModel<M>, Q : Query {
//		tableView.reloadData()
//	}
//}
