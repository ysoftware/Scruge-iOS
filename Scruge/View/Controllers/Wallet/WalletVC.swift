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

	let vm = AccountAVM()

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
