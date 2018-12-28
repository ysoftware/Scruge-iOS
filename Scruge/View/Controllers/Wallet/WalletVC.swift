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

	@IBOutlet weak var scrollView: UIScrollView!

	// top view
	@IBOutlet weak var loadingView: LoadingView!
	@IBOutlet weak var accountNameLabel: UILabel!
	@IBOutlet weak var balanceLabel: UILabel!

	// expandable views
	@IBOutlet weak var exchangeExpandable: ExpandableView!
	@IBOutlet weak var dataExpandable: ExpandableView!
	@IBOutlet weak var investmentsExpandable: ExpandableView!
	@IBOutlet weak var actionsExpandable: ExpandableView!

	// contents
	@IBOutlet weak var walletActionsView: WalletTransactionsView!
	@IBOutlet weak var walletDataView: WalletDataView!

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
		setupActions()
		setupExpandableViews()
		setupScrollView()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		setupVM()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		verifyWallet()
	}

	private func setupScrollView() {
		if #available(iOS 11.0, *) {
			scrollView.contentInsetAdjustmentBehavior = .never
			scrollView.contentInset.bottom = tabBarController?.tabBar.frame.height ?? 0
		}
		automaticallyAdjustsScrollViewInsets = false
	}

	private func setupExpandableViews() {
		exchangeExpandable.delegate = self
		dataExpandable.delegate = self
		investmentsExpandable.delegate = self
		actionsExpandable.delegate = self
	}

	private func setupActions() {
		walletDataView.exportPrivateKeyTap = { [unowned self] wallet in
			self.alert("not implemented yet")
		}
		walletDataView.copyPublicKeyTap = { wallet in
			UIPasteboard.general.string = wallet?.rawPublicKey
		}
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
		navigationController?.navigationBar.isHidden = true
	}

	private func updateView() {
		accountNameLabel.text = accountVM?.name ?? ""
	}

	private func updateBalance() {
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
				updateView()
			default: break
			}
	}
}

extension WalletViewController: ExpandableViewDelegate {

	func expandableView(_ sender: ExpandableView, didChangeTo state: ExpandableViewState) {
		guard state == .expanded else { return }
		
		switch sender {
		case exchangeExpandable:
			break
		case dataExpandable:
			walletDataView.updateViews()
		case investmentsExpandable:
			break
		case actionsExpandable:
			walletActionsView.accountName = accountVM?.name
		default: break
		}
	}
}

extension WalletViewController: ViewModelDelegate {

	func didUpdateData<M>(_ viewModel: ViewModel<M>) where M : Equatable {
		updateBalance()
	}
}
