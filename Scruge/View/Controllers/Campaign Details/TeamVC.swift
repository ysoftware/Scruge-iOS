//
//  TeamVC.swift
//  Scruge
//
//  Created by ysoftware on 31/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class TeamViewController: UIViewController {

	@IBOutlet weak var tableView:UITableView!

	var vm:CampaignVM!

	override func viewDidLoad() {
		super.viewDidLoad()

		setupTableView()
	}

	private func setupTableView() {

		tableView.estimatedRowHeight = 400
		tableView.rowHeight = UITableView.automaticDimension
		tableView.register(UINib(resource: R.nib.memberCell),
						   forCellReuseIdentifier: R.reuseIdentifier.memberCell.identifier)
		tableView.reloadData()
	}

	private func openSocialPage(_ element:Social) {
		guard let url = URL(string: element.url) else { return }
		Service.presenter.presentSafariViewController(in: self, url: url)
	}
}

extension TeamViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return vm.team.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.memberCell,
											 for: indexPath)!
			.setup(with: vm.team[indexPath.row]) { [unowned self] social in
				self.openSocialPage(social)
			}
	}
}
