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

	private var activeVoting:[Voting] = []
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
				reloadData()
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
		tableView.register(UINib(resource: R.nib.voteNotificationCell),
						   forCellReuseIdentifier: R.reuseIdentifier.voteNotificationCell.identifier)
	}

	private func setupVM() {
		tableUpdateHandler = ArrayViewModelUpdateHandler(with: tableView)
		vm.delegate = self
		reloadData()
	}

	// MARK: - Methods

	@objc func reloadData() {
		vm.reloadData()

		#warning("refactor to view model")
		Service.api.getVoteNotifications { result in
			switch result {
			case .success(let response):
				self.activeVoting = response.votings
			case .failure:
				self.activeVoting = []
			}
			self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
		}
	}
}

extension ActivityViewController: UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return section == 0 ? activeVoting.count : vm.numberOfItems
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.voteNotificationCell,
												 for: indexPath)!.setup(with: activeVoting[indexPath.row])
		}

		let vm = self.vm.item(at: indexPath.row, shouldLoadMore: true)
		return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.activityUpdateCell,
											 for: indexPath)!
			.setup(with: vm)
			.campaignTap { [unowned self] update in
				Service.presenter.presentCampaignViewController(in: self, id: update.campaignId)
			}
			.updateTap { [unowned self] update in
				Service.presenter.presentContentViewController(in: self, for: vm)
			}
	}
}

extension ActivityViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		if indexPath.section == 0 {
			let id = activeVoting[indexPath.row].campaign.id
			Service.presenter.presentVoteViewController(in: self, with: id)
		}
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
