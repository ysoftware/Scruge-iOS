//
//  BountiesVC.swift
//  Scruge
//
//  Created by ysoftware on 18/02/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import UIKit
import MVVM

final class BountiesViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var tableView:UITableView!

	// MARK: - Properties

	var projectVM:ProjectVM!
	private var vm:BountyAVM!

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		localize()
		setupVM()
		setupViews()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNavigationBar()
	}

	private func setupViews() {
		tableView.contentInset.top = 15
		tableView.contentInset.bottom = 15

		tableView.estimatedRowHeight = 100
		tableView.rowHeight = UITableView.automaticDimension

		tableView.register(UINib(resource: R.nib.bountyCell),
									forCellReuseIdentifier: R.reuseIdentifier.bountyCell.identifier)
	}

	private func setupVM() {
		vm = BountyAVM(projectVM)
		vm.delegate = self
		vm.reloadData()
	}

	private func setupNavigationBar() {
		navigationController?.navigationBar.isHidden = false
		makeNavbarNormal(with: projectVM.name)
		preferSmallNavbar()
	}

	// MARK: - Actions


	// MARK: - Methods


}

extension BountiesViewController: ArrayViewModelDelegate {

	func didUpdateData<M, VM, Q>(_ arrayViewModel: ArrayViewModel<M, VM, Q>,
								 _ update: MVVM.Update) where M : Equatable, VM : ViewModel<M>, Q : Query {
		tableView.reloadData()
	}
}

extension BountiesViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		Service.presenter.presentBountyViewController(in: self,
													  bountyVM: vm[indexPath.row],
													  projectVM: projectVM)
	}
}

extension BountiesViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView,
				   numberOfRowsInSection section: Int) -> Int {
		return vm.numberOfItems
	}

	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.bountyCell,
											 for: indexPath)!
			.setup(with: vm[indexPath.row])
	}
}
