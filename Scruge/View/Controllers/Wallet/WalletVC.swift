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
		tableView.register(UINib(resource: R.nib.accountCell),
						   forCellReuseIdentifier: R.reuseIdentifier.accountCell.identifier)
	}

	private func setupVM() {
		vm.delegate = self
		vm.reloadData()
	}

	private func setupNavigationBar() {
		title = "Accounts"
	}

	private func setupActions() {
		loadingView.errorViewDelegate = self
		loadingView.errorView.setButtonTitle("Get started")
	}

	// MARK: - Methods

	private func updateStatus() {
		switch vm.status {
		case .error(let error):
			loadingView.set(state: .error(ErrorHandler.message(for: error)))
		case .loading:
			loadingView.set(state: .loading)
		case .noAccounts:
			loadingView.set(state: .error("No accounts are associated with imported private key."))
		case .noKey:
			loadingView.set(state: .error("You can import your key or create a new one."))
		case .ready:
			loadingView.set(state: .ready)
		}

		switch vm.status {
		case .ready:
			navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Options",
																style: .plain,
																target: self,
																action: #selector(showSettings))
		default:
			navigationItem.rightBarButtonItem = nil
		}
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
		guard let wallet = Service.wallet.getWallet() else {
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
		guard let wallet = Service.wallet.getWallet() else {
			// should not happen
			return
		}

		Service.presenter.presentPasscodeViewController(in: self, message: "") { input in
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

	}
}

extension WalletViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		let account = self.vm.item(at: indexPath.row)

		if account.isLocked {
			let message = "Enter your passcode to unlock this account"
			Service.presenter.presentPasscodeViewController(in: self, message: message) { input in
				guard let passcode = input else { return }

				let result = account.unlock(passcode)
				self.alert(result ? "Account unlocked for 3 minutes, private key can be accessed." : "Error")
			}
		}
		else {
			self.alert("Account is already unlocked, private key can be accessed")
		}
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
