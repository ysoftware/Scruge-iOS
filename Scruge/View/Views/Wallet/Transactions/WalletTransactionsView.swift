//
//  WalletTransactionsView.swift
//  Scruge
//
//  Created by ysoftware on 27/12/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import MVVM

final class WalletTransactionsView: UIView {

	private let tableView = UITableView(frame: .zero)
	private var vm:ActionsAVM?

	var accountName:String? {
		didSet {
			guard let name = accountName else {
				vm = nil
				tableView.reloadData()
				return
			}
			vm = ActionsAVM(accountName: name)
			vm?.delegate = self
			vm?.query = ActionsQuery()
			vm?.reloadData()
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}

	private func setup() {
		addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
		tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		tableView.heightAnchor.constraint(equalToConstant: 250).isActive = true

		tableView.backgroundColor = .clear
		backgroundColor = .clear

		tableView.delegate = self
		tableView.dataSource = self

		tableView.estimatedRowHeight = 60
		tableView.rowHeight = UITableView.automaticDimension

		tableView.register(UINib(resource: R.nib.transactionCell),
						   forCellReuseIdentifier: R.reuseIdentifier.transactionCell.identifier)
	}
}

extension WalletTransactionsView: ArrayViewModelDelegate {

	func didUpdateData<M, VM, Q>(_ arrayViewModel: ArrayViewModel<M, VM, Q>,
								 _ update: MVVM.Update)
		where M : Equatable, VM : ViewModel<M>, Q : Query {

			tableView.reloadData()
			layoutIfNeeded()
	}
}

extension WalletTransactionsView: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

extension WalletTransactionsView: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return vm?.numberOfItems ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let vm = vm else { return UITableViewCell() }
		let item = vm.item(at: indexPath.row, shouldLoadMore: true)
		return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.transactionCell,
											 for: indexPath)!.setup(item)
	}
}
