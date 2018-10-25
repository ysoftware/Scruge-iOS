//
//  WalletVC.swift
//  Scruge
//
//  Created by ysoftware on 17/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import MVVM

final class WalletViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var loadingView: LoadingView!

	// MARK: - Property

	private let vm = AccountAVM()

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		setupNavigationBar()
		setupTable()
		setupActions()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		setupVM()
	}

	private func setupTable() {
		tableView.refreshControl = UIRefreshControl()
		tableView.refreshControl!.addTarget(self, action: #selector(reloadData), for: .valueChanged)

		tableView.register(UINib(resource: R.nib.accountCell),
						   forCellReuseIdentifier: R.reuseIdentifier.accountCell.identifier)
	}

	private func setupVM() {
		vm.delegate = self
		reloadData()
	}

	private func setupNavigationBar() {
		title = "Accounts"
	}

	private func setupActions() {
		loadingView.errorView.setButtonTitle("Get started")
		switch vm.status {
		case .noKey:
			loadingView.errorViewDelegate = self
		default:
			loadingView.errorViewDelegate = nil
		}

		switch vm.status {
		case .ready, .noAccounts:
			navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Options",
																style: .plain,
																target: self,
																action: #selector(showSettings))
		default:
			navigationItem.rightBarButtonItem = nil
		}
	}

	// MARK: - Methods

	@objc func reloadData() {
		vm.reloadData()
	}

	private func updateStatus() {
		switch vm.status {
		case .error(let error):
			loadingView.set(state: .error(ErrorHandler.message(for: error)))
			tableView.refreshControl?.endRefreshing()
		case .loading:
			loadingView.set(state: .loading)
		case .noAccounts:
			loadingView.set(state: .error("No accounts are associated with imported private key."))
		case .noKey:
			loadingView.set(state: .error("You can import your key or create a new one."))
		case .ready:
			loadingView.set(state: .ready)
			tableView.refreshControl?.endRefreshing()
		}

		setupActions()
	}

	@objc func showSettings() {
		let showPublic = UIAlertAction(title: "Show public key",
									  style: .default) { _ in
										self.showPublicKey()
		}

		let export = UIAlertAction(title: "Export private key",
									  style: .destructive) { _ in
										self.exportPrivateKey()
		}

		let delete = UIAlertAction(title: "Delete wallet",
									  style: .destructive) { _ in
										self.deleteWallet()
		}

		let cancel = UIAlertAction(title: "Cancel",
								   style: .cancel) { _ in
		}

		Service.presenter.presentActions(in: self,
										 title: "Select action",
										 message: "", actions: [showPublic, export, delete, cancel])
	}

	private func deleteWallet() {
		self.ask(question: "Are you sure?") { response in
			if response {
				self.vm.deleteWallet()
			}
		}
	}

	private func showPublicKey() {
		guard let wallet = vm.getWallet() else {
			// should not happen
			return
		}

		Service.presenter.presentPasscodeViewController(in: self, message: "") { input in
			guard let passcode = input else { return }

			try? wallet.timedUnlock(passcode: passcode, timeout: 100)
			if !wallet.isLocked(), let key = wallet.rawPublicKey {

				// TO-DO: make it pretty
				self.alert("\(key)")
			}
			else {
				self.alert("Incorrect passcode")
			}
		}
	}

	private func exportPrivateKey() {
		guard let wallet = vm.getWallet() else {
			// should not happen
			return
		}

		let message = "Enter your passcode to unlock the wallet."
		Service.presenter.presentPasscodeViewController(in: self, message: message) { input in
			guard let passcode = input else { return }

			if let key = try? wallet.decrypt(passcode: passcode) {

				// TO-DO: make it pretty
				self.alert("\(key.rawPrivateKey())")
			}
			else {
				self.alert("Incorrect passcode")
			}
		}
	}

	private func openImportKey() {
		Service.presenter.presentImporKeyViewController(in: self)
	}

	private func openCreateKey() {
		let message = "Enter passcode for this wallet."
		Service.presenter.presentPasscodeViewController(in: self, message: message) { input in
			guard let passcode = input else { return }

			Service.wallet.createKey(passcode) { account in
				if account != nil {
					self.vm.reloadData()
				}
				else {
					self.alert("There was an error while creating wallet.")
				}
			}
		}
	}
}

extension WalletViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		
	}
}

extension WalletViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return vm.numberOfItems
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.accountCell,
											 for: indexPath)!
			.setup(with: vm.item(at: indexPath.row))
	}
}

extension WalletViewController: ArrayViewModelDelegate {

	func didUpdateData<M, VM, Q>(_ arrayViewModel: ArrayViewModel<M, VM, Q>,
								 _ update: MVVM.Update)
		where M : Equatable, VM : ViewModel<M>, Q : Query {

			tableView.reloadData()
			updateStatus()
	}
}

extension WalletViewController: ErrorViewDelegate {

	// get started button click
	func didTryAgain() {
		let createKey = UIAlertAction(title: "Create new key",
									  style: .default) { _ in
										self.openCreateKey()
		}

		let importKey = UIAlertAction(title: "Import existing key",
									  style: .default) { _ in
										self.openImportKey()
		}

		let cancel = UIAlertAction(title: "Cancel",
								   style: .cancel) { _ in
		}

		Service.presenter.presentActions(in: self,
										 title: "Select action",
										 message: "", actions: [createKey, importKey, cancel])
	}
}
