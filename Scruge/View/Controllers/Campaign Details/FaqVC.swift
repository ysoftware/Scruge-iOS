//
//  FaqVC.swift
//  Scruge
//
//  Created by ysoftware on 12/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import MVVM

final class FaqViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var tableView: UITableView!

	// MARK: - Properties

	public var vm:FaqAVM!

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		localize()
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
		tableView.register(UINib(resource: R.nib.faqCell),
						   forCellReuseIdentifier: R.reuseIdentifier.faqCell.identifier)
	}
}

extension FaqViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return vm.numberOfItems
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.faqCell,
//											 for: indexPath)!
//			.setup(with: vm.item(at: indexPath.row))
		return UITableViewCell()
	}
}

extension FaqViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

extension FaqViewController: ArrayViewModelDelegate {

	func didUpdateData<M, VM, Q>(_ arrayViewModel: ArrayViewModel<M, VM, Q>, _ update: MVVM.Update)
		where M : Equatable, VM : ViewModel<M>, Q : Query {
			tableView.reloadData()
	}
}
