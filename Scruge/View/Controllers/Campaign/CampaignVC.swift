//
//  CampaignVC.swift
//  Scruge
//
//  Created by ysoftware on 01/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import MVVM

final class CampaignViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var tableView: UITableView!

	// MARK: - Actions

	// MARK: - Properties

	var campaignVM:CampaignVM!

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		setupTableView()
	}

	func setupVM() {
		campaignVM.delegate = self
		campaignVM.load()
	}

	func setupTableView() {
		tableView.delaysContentTouches = false
		tableView.estimatedRowHeight = 400
		tableView.rowHeight = UITableView.automaticDimension
		tableView.register(UINib(resource: R.nib.campaignCell),
						   forCellReuseIdentifier: R.reuseIdentifier.campaignCell.identifier)
	}
}

extension CampaignViewController: UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		return 5
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		switch indexPath.section {
		case 0:
			let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.campaignCell,
													 for: indexPath)!
			return cell.setup(campaignVM) { [unowned self] in
				Presenter.presentCampaignHTMLViewController(in: self, for: self.campaignVM)
			}
		default:
			return UITableViewCell()
		}
	}
}

extension CampaignViewController: ViewModelDelegate {

	func didUpdateData<M>(_ viewModel: ViewModel<M>) where M : Equatable {
		tableView.reloadData()
	}
}
