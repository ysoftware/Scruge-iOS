//
//  ActivityVC.swift
//  Scruge
//
//  Created by ysoftware on 03/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import MVVM

final class ActivityViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var loadingView: LoadingView!
	
	// MARK: - Properties

	private let vm = UpdateAVM(.activity)
	private var tableUpdateHandler:ArrayViewModelUpdateHandler!

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		setupVM()
		setupTableView()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		setupNavigationBar()

		switch vm.state {
		case .ready, .error:
			if vm.numberOfItems == 0 {
				vm.reloadData()
			}
		default: break
		}
	}

	func setupNavigationBar() {
		makeNavbarNormal(with: "Activity")
		preferLargeNavbar()
	}

	private func setupTableView() {
		tableView.delaysContentTouches = false
		tableView.refreshControl = UIRefreshControl()
		tableView.refreshControl?.addTarget(self, action: #selector(reloadData), for: .valueChanged)

		tableView.contentInset.top = 15
		tableView.contentInset.bottom = 15

		tableView.estimatedRowHeight = 100
		tableView.rowHeight = UITableView.automaticDimension
		tableView.register(UINib(resource: R.nib.activityUpdateCell),
						   forCellReuseIdentifier: R.reuseIdentifier.activityUpdateCell.identifier)
	}

	private func setupVM() {
		tableUpdateHandler = ArrayViewModelUpdateHandler(with: tableView)
		vm.delegate = self
		reloadData()
	}

	// MARK: - Methods

	@objc func reloadData() {
		vm.reloadData()
	}
}

extension ActivityViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return vm.numberOfItems
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let vm = self.vm.item(at: indexPath.row, shouldLoadMore: true)
		return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.activityUpdateCell,
											 for: indexPath)!
			.setup(with: vm)
//			.setupTap(campaign: { [unowned self] in
//				Service.presenter.presentCampaignViewController(in: self, id: vm.campaignId)
//			}, update: { [unowned self] in
//				Service.presenter.presentContentViewController(in: self, for: vm)
//			})
	}
}

extension ActivityViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

	}
}

extension ActivityViewController: ArrayViewModelDelegate {

	func didUpdateData<M, VM, Q>(_ arrayViewModel: ArrayViewModel<M, VM, Q>,
								 _ update: MVVM.Update)
		where M : Equatable, VM : ViewModel<M>, Q : Query {
			tableUpdateHandler.handle(update)
	}

	func didChangeState<M, VM, Q>(_ arrayViewModel: ArrayViewModel<M, VM, Q>,
								  to state: ArrayViewModelState)
		where M : Equatable, VM : ViewModel<M>, Q : Query {

			switch vm.state {
			case .error(let error):
				tableView.refreshControl?.endRefreshing()
				let message = ErrorHandler.message(for: error)
				loadingView.set(state: .error(message))
			case .loading, .initial:
				loadingView.set(state: .loading)
			case .ready:
				tableView.refreshControl?.endRefreshing()
				if vm.isEmpty {
					loadingView.set(state: .error("No updates"))
				}
				else {
					loadingView.set(state: .ready)
				}
			default: break
			}
	}
}
