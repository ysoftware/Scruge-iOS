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

	@IBOutlet weak var accountNameLabel: UILabel!
	@IBOutlet weak var balanceLabel: UILabel!

	@IBOutlet weak var loadingView: LoadingView!

	// MARK: - Property

	private let vm = AccountAVM()
	private var accountVM:AccountVM?

	// MARK: - Setup

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavigationBar()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		setupVM()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		verifyWallet()
	}

	private func verifyWallet() {
		if Service.wallet.getWallet() == nil {
			Service.presenter.replaceWithWalletStartViewController(with: self)
		}
	}

	private func setupVM() {
		vm.delegate = self
		vm.reloadData()
	}

	private func setupNavigationBar() {
		makeNavbarTransparent()
		preferSmallNavbar()
	}

	private func updateView() {
		accountNameLabel.text = accountVM?.name ?? ""
		if let str = accountVM?.balanceString() {
			balanceLabel.attributedText = str
		}
		else {
			balanceLabel.text = ""
		}
	}

	// MARK: - Actions

	private func updateStatus() {
		switch vm.state {
		case .error(WalletError.noKey):
			Service.presenter.replaceWithWalletStartViewController(with: self)
		case .error(WalletError.noAccounts):
			Service.presenter.replaceWithWalletNoAccountController(with: self)
		case .error(let error):
			loadingView.set(state: .error(ErrorHandler.message(for: error)))

		case .loading:
			loadingView.set(state: .loading)
		case .ready:
			loadingView.set(state: .ready)
		default: break
		}
	}

	@IBAction func showSettings() {
		let delete = UIAlertAction(title: "Delete wallet",
								   style: .destructive) { _ in
									self.deleteWallet()
		}

		let change = UIAlertAction(title: "Switch account",
								   style: .default) { _ in
									self.presentWalletPicker()
		}

		let cancel = UIAlertAction(title: "Cancel",
								   style: .cancel) { _ in
		}

		let actions = vm.numberOfItems == 1 ? [delete, cancel] : [change, delete, cancel]

		Service.presenter.presentActions(in: self,
										 title: "Select action",
										 message: "", actions: actions)
	}

	// MARK: - Methods

	private func selectVM() {
		guard let account = vm.selectedAccount else { return presentWalletPicker() }

		accountVM = account
		accountVM?.delegate = self
		accountVM?.updateBalance()
	}

	private func presentWalletPicker() {

		guard vm.numberOfItems > 0 else {
			return
		}

		// auto select the 1st account
		if vm.numberOfItems == 1 {
			Service.settings.set(.selectedAccount, value: vm.item(at: 0).name)
			vm.reloadData()
			return
		}

		let title = """
Select an account that you want to make investments with and receive ICO tokens on.

You will not be able to change it after you make first investment.
"""

		Service.presenter.presentWalletPicker(in: self, title: title) { [unowned self] account in
			guard let account = account else {
				return self.presentWalletPicker()
			}

			Service.settings.set(.selectedAccount, value: account.name)
			self.vm.reloadData()
		}
	}

	private func deleteWallet() {
		let t = "Are you sure to delete your wallet?"
		let q = "Make sure to export your private key because there is no way it can be retrieved later."
		self.ask(title: t, question: q) { response in
			if response {
				self.vm.deleteWallet()
				Service.presenter.replaceWithWalletStartViewController(with: self)
			}
		}
	}

	private func openImportKey() {
		Service.presenter.presentImporKeyViewController(in: self)
	}
}

extension WalletViewController: ArrayViewModelDelegate {

	func didUpdateData<M, VM, Q>(_ arrayViewModel: ArrayViewModel<M, VM, Q>,
								 _ update: MVVM.Update)
		where M : Equatable, VM : ViewModel<M>, Q : Query {

			updateStatus()

			switch update {
			case .reload:
				selectVM()
			default: break
			}
	}
}

extension WalletViewController: ViewModelDelegate {

	func didUpdateData<M>(_ viewModel: ViewModel<M>) where M : Equatable {

		updateView()
	}
}
