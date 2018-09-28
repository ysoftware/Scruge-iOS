//
//  CampaignListVC.swift
//  Scruge
//
//  Created by ysoftware on 28/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class TrendingViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var tableView: UITableView!

	// MARK: - Properties

	let vm = CampaignAVM()

	// MARK: - Methods

	override func viewDidLoad() {
		super.viewDidLoad()

		setupTableView()
	}

	func setupTableView() {
		tableView.estimatedRowHeight = 300
		tableView.rowHeight = UITableView.automaticDimension
	}
}

extension TrendingViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return vm.numberOfItems
	}

	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.campaignCell,
												 for: indexPath)!
		return cell.setup(vm.item(at: indexPath.row, shouldLoadMore: true))
	}
}

extension TrendingViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
