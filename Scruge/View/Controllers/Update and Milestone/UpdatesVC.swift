//
//  UpdatesVC.swift
//  Scruge
//
//  Created by ysoftware on 03/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import MVVM

final class UpdatesViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var tableView: UITableView!

	// MARK: - Properties

	public var vm:UpdateAVM!

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		setupTableView()
		setupVM()
	}

	private func setupVM() {
		vm.delegate = self
		vm.reloadData()
	}

	private func setupTableView() {
		tableView.estimatedRowHeight = 400
		tableView.rowHeight = UITableView.automaticDimension
		tableView.register(UINib(resource: R.nib.updateCell),
						   forCellReuseIdentifier: R.reuseIdentifier.updateCell.identifier)
	}
}

extension UpdatesViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return vm.numberOfItems
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.updateCell,
											 for: indexPath)!
			.setup(with: vm.item(at: indexPath.row), hideDate: false)
	}
}

extension UpdatesViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

extension UpdatesViewController: ArrayViewModelDelegate {

	func didUpdateData<M, VM, Q>(_ arrayViewModel: ArrayViewModel<M, VM, Q>, _ update: MVVM.Update)
		where M : Equatable, VM : ViewModel<M>, Q : Query {
		tableView.reloadData()
	}

	func didChangeState(to state: ArrayViewModelState) {

	}
}
