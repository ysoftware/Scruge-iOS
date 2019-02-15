//
//  BountiesVC.swift
//  Scruge
//
//  Created by ysoftware on 15/02/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import UIKit
import MVVM

final class BountiesViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var loadingView: LoadingView!

	// MARK: - Properties

	private let projectsVM = ProjectsAVM()
	private var tableUpdateHandler:ArrayViewModelUpdateHandler!

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		localize()
		setupViews()
		setupActions()
		setupNavigationBar()
		setupTableView()
		setupVM()
	}

	private func setupViews() {

	}

	private func setupActions() {

	}

	private func setupTableView() {
		tableView.refreshControl = UIRefreshControl()
		tableView.refreshControl?.addTarget(self, action: #selector(reloadData), for: .valueChanged)

		tableView.estimatedRowHeight = 80
		tableView.rowHeight = UITableView.automaticDimension
		tableView.register(UINib(resource: R.nib.projectCell),
									 forCellReuseIdentifier: R.reuseIdentifier.projectCell.identifier)
	}

	private func setupVM() {
		tableUpdateHandler = ArrayViewModelUpdateHandler(with: tableView)
		projectsVM.delegate = self
		projectsVM.reloadData()
	}

	private func setupNavigationBar() {
		makeNavbarNormal(with: R.string.localizable.title_bounties())
		preferLargeNavbar()
	}

	// MARK: - Actions

	@objc func reloadData() {
		projectsVM.reloadData()
	}

	// MARK: - Methods


}

extension BountiesViewController: ArrayViewModelDelegate {

	func didUpdateData<M, VM, Q>(_ arrayViewModel: ArrayViewModel<M, VM, Q>,
								 _ update: MVVM.Update)
		where M : Equatable, VM : ViewModel<M>, Q : Query {

			tableUpdateHandler.handle(update)
	}

	func didChangeState<M, VM, Q>(_ arrayViewModel: ArrayViewModel<M, VM, Q>,
								  to state: ArrayViewModelState)
		where M : Equatable, VM : ViewModel<M>, Q : Query {

			switch projectsVM.state {
			case .error(let error):
				let message = ErrorHandler.message(for: error)
				loadingView.set(state: .error(message))
				tableView.refreshControl?.endRefreshing()
			case .loading, .initial:
				loadingView.set(state: .loading)
			case .ready:
				tableView.refreshControl?.endRefreshing()
				if projectsVM.isEmpty {
					loadingView.set(state: .error(R.string.localizable.error_no_projects()))
				}
				else {
					loadingView.set(state: .ready)
				}
			default: break
			}
	}
}

extension BountiesViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

	}
}

extension BountiesViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return projectsVM.numberOfItems
	}

	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.projectCell,
											 for: indexPath)!
			.setup(with: projectsVM[indexPath.row])
	}
}
