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

	// MARK: - Property

	var vm:AccountAVM!

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		vm = AccountAVM(passcode: "passcode")

		setupNavigationBar()
		setupTable()
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
		vm.reloadData()
		vm.delegate = self
	}

	private func setupNavigationBar() {
		title = "Accounts"
		
		let importButton = UIBarButtonItem(title: "Import Key", style: .plain,
										   target: self, action: #selector(openImportKey))
		navigationItem.rightBarButtonItem = importButton
	}

	// MARK: - Methods

	@objc func openImportKey(_ sender:Any) {
		Presenter.presentImporKeyViewController(in: self)
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
	}
}
