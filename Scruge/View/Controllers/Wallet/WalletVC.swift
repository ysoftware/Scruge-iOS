//
//  WalletVC.swift
//  Scruge
//
//  Created by ysoftware on 17/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import MVVM
import Result

final class WalletViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var loadingView: LoadingView!

	// MARK: - Property

	private let vm = AccountAVM()

	// for wallet picking
	var pickerBlock:((AccountVM)->Void)?

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		setupTable()
		setupActions()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		setupVM()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNavigationBar()
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
		title = "Wallet"

		if #available(iOS 11.0, *) {
			navigationController?.navigationBar.prefersLargeTitles = true
		}

		if pickerBlock != nil {
			let cancelButton = UIBarButtonItem(title: "Cancel",
										 style: .plain,
										 target: self, action: #selector(cancel))
			navigationItem.leftBarButtonItem = cancelButton
		}
	}

	private func setupActions() {
		switch vm.state {
		case .error(WalletError.noKey):
			loadingView.errorView.setButtonTitle("Create new account")
			loadingView.errorViewDelegate = self
		case .error(WalletError.noAccounts):
			loadingView.errorView.setButtonTitle("Create new account")
			loadingView.errorViewDelegate = self
		default:
			loadingView.errorViewDelegate = nil
		}

		switch vm.state {

		case .ready, .error(WalletError.noAccounts):
			navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Options",
																style: .plain,
																target: self,
																action: #selector(showSettings))
		default:
			navigationItem.rightBarButtonItem = nil
		}
	}

	// MARK: - Methods

	@objc func cancel() {
		dismiss(animated: true)
	}

	@objc func reloadData() {
		vm.reloadData()
	}

	private func updateStatus() {
		switch vm.state {
		case .error(WalletError.noAccounts):
			loadingView.set(state: .error(ErrorHandler.message(for: WalletError.noAccounts)))
		case .error(WalletError.noKey):
			loadingView.set(state: .error("You have no blockchain accounts added."))
		case .error(let error):
			loadingView.set(state: .error(ErrorHandler.message(for: error)))
			tableView.refreshControl?.endRefreshing()

		case .loading:
			loadingView.set(state: .loading)
		case .ready:
			loadingView.set(state: .ready)
			tableView.refreshControl?.endRefreshing()
		default: break
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
		Service.presenter.presentPasscodeViewController(in: self, message: "") { input in
			guard let passcode = input else { return }

			self.vm.getPublicKey(passcode: passcode) { result in
				switch result {
				case .success(let key):
					self.alert(key)
				case .failure(let error):
					self.alert(error)
				}
			}
		}
	}

	private func exportPrivateKey() {
		Service.presenter.presentPasscodeViewController(in: self, message: "") { input in
			guard let passcode = input else { return }

			self.vm.exportPrivateKey(passcode: passcode) { result in
				switch result {
				case .success(let key):
					self.alert(key)
				case .failure(let error):
					self.alert(error)
				}
			}
		}
	}

	private func openImportKey() {
		Service.presenter.presentImporKeyViewController(in: self)
	}
}

extension WalletViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		guard let block = pickerBlock else { return }
		let wallet = vm.item(at: indexPath.row)

		ask(question: "Use this wallet for contribution?") { response in
			if response {
				self.dismiss(animated: true) {
					block(wallet)
				}
			}
		}
	}
}

extension WalletViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return vm.numberOfItems
	}

	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
		switch vm.state {
		case .error(WalletError.noKey):
			Service.presenter.presentImporKeyViewController(in: self)
		default: break
		}
	}
}
