//
//  WalletPickerVC.swift
//  Scruge
//
//  Created by ysoftware on 29/11/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import MVVM

final class WalletPickerViewController: UIViewController {

	@IBOutlet weak var saveButton: Button!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!

	let vm = AccountAVM()

	var block:((AccountVM?)->Void)!
	var string:String!

	override func viewDidLoad() {
		super.viewDidLoad()

		localize()

		setupVM()
		setupButton()
		setupView()
	}

	private func setupView() {
		titleLabel.text = string

		tableView.register(UINib(resource: R.nib.accountCell),
						   forCellReuseIdentifier: R.reuseIdentifier.accountCell.identifier)
		tableView.estimatedRowHeight = 44
		tableView.rowHeight = UITableView.automaticDimension
	}

	private func setupButton() {
		saveButton.addClick(self, action: #selector(save))
	}

	private func setupVM() {
		vm.reloadData()
		vm.delegate = self
	}

	@objc func save() {
		guard let index = tableView.indexPathForSelectedRow?.row else { return }

		block(vm.item(at: index))
		dismiss(animated: true)
	}
}

extension WalletPickerViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return vm.numberOfItems
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.accountCell,
											 for: indexPath)!.setup(with: vm.item(at: indexPath.row))
	}
}

extension WalletPickerViewController: ArrayViewModelDelegate {

	func didUpdateData<M, VM, Q>(_ arrayViewModel: ArrayViewModel<M, VM, Q>,
								 _ update: MVVM.Update)
		where M : Equatable, VM : ViewModel<M>, Q : Query {

			switch update {
			case .reload:
				tableView.reloadData()
				tableViewHeightConstraint.constant = tableView.contentSize.height
			default: break
			}
	}
}
