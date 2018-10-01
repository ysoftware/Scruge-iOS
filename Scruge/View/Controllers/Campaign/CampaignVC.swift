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

	var vm:CampaignVM!

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		setupTableView()
	}

	func setupVM() {
		vm.delegate = self
		vm.load()
	}

	func setupTableView() {
		tableView.delaysContentTouches = false
		tableView.estimatedRowHeight = 400
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedSectionHeaderHeight = 30
		tableView.sectionHeaderHeight = UITableView.automaticDimension
		tableView.estimatedSectionFooterHeight = 30
		tableView.sectionFooterHeight = UITableView.automaticDimension

		tableView.register(UINib(resource: R.nib.campaignCell),
						   forCellReuseIdentifier: R.reuseIdentifier.campaignCell.identifier)
		tableView.registerHeaderFooterView(R.nib.campHeader)
		tableView.registerHeaderFooterView(R.nib.campFooter)
	}
}

extension CampaignViewController: UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		return 5
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0, 1, 2: return 1
		case 3: return vm.topCommentsVM?.numberOfItems ?? 0
		case 4: return vm.rewardsVM?.numberOfItems ?? 0
		default: return 0
		}
	}

	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		switch indexPath.section {
		case 0:
			let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.campaignCell,
													 for: indexPath)!
			return cell.setup(vm)
		default:
			return UITableViewCell()
		}
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header = tableView.dequeueReusableHeaderFooterView(
			withIdentifier: R.reuseIdentifier.campaignHeader.identifier) as! CampaignHeader
		switch section {
		case 1: if let vm = vm.currentMilestoneVM { return header.setup(with: vm) }
		case 2: if let vm = vm.lastUpdateVM { return header.setup(with: vm) }
		case 3: if let vm = vm.topCommentsVM { return header.setup(with: vm, for: self.vm) }
		case 4: if let vm = vm.rewardsVM { return header.setup(with: vm) }
		default: break
		}
		return nil
	}

	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let footer = tableView.dequeueReusableHeaderFooterView(
			withIdentifier: R.reuseIdentifier.campaignFooter.identifier) as! CampaignFooter
		let title:String
		switch section {
		case 0: title = "Read the full story →"
		case 1: title = "See all milestones →"
		case 2: title = "See all updates →"
		case 3: title = "See all comments →"
		default: return nil
		}
		return footer.setup(with: title)
	}
}

extension CampaignViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch (indexPath.row, indexPath.section) {
		case (0, 1):
			Presenter.presentCampaignHTMLViewController(in: self, for: vm)
		default:
			return
		}
	}
}

extension CampaignViewController: ViewModelDelegate {

	func didUpdateData<M>(_ viewModel: ViewModel<M>) where M : Equatable {
		tableView.reloadData()
	}
}
