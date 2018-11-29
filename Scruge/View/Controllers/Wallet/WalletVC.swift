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

	// MARK: - Setup

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		setupVM()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		setupNavigationBar()
		if Service.wallet.getWallet() == nil {
			Service.presenter.replaceWithWalletStartViewController(with: self)
		}
	}

	private func setupVM() {
		vm.delegate = self
		reloadData()
	}

	private func setupNavigationBar() {
		makeNavbarTransparent()
		preferSmallNavbar()
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

		setupNavigationBar()
		updateView()
	}

	private func updateView() {
		let acc = vm.numberOfItems > 0 ? vm.item(at: 0) : nil
		accountNameLabel.text = acc?.name ?? ""
		balanceLabel.text = acc?.balanceString ?? "0.0000 EOS\n0.0000 SCR"
	}

	@IBAction func showSettings() {
		let delete = UIAlertAction(title: "Delete wallet",
									  style: .destructive) { _ in
										self.deleteWallet()
		}

		let cancel = UIAlertAction(title: "Cancel",
								   style: .cancel) { _ in
		}

		Service.presenter.presentActions(in: self,
										 title: "Select action",
										 message: "", actions: [delete, cancel])
	}

	private func deleteWallet() {
		self.ask(question: "Are you sure?") { response in
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
	}
}
