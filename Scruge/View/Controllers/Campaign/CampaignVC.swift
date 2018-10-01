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

	@objc
	func headerTap(_ tap:UITapGestureRecognizer) {
	}

	@objc
	func footerTap(_ tap:UITapGestureRecognizer) {
		switch tap.view!.tag {
		case 0:
			Presenter.presentCampaignHTMLViewController(in: self, for: vm)
		default: break
		}
	}

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

		tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: -10, right: 0)
		tableView.estimatedRowHeight = 400
		tableView.rowHeight = UITableView.automaticDimension

		tableView.register(UINib(resource: R.nib.campaignCell),
						   forCellReuseIdentifier: R.reuseIdentifier.campaignCell.identifier)
		tableView.register(UINib(resource: R.nib.milestoneCell),
						   forCellReuseIdentifier: R.reuseIdentifier.milestoneCell.identifier)
		tableView.register(UINib(resource: R.nib.updateCell),
						   forCellReuseIdentifier: R.reuseIdentifier.updateCell.identifier)
		tableView.registerHeaderFooterView(R.nib.campHeader)
		tableView.registerHeaderFooterView(R.nib.campFooter)
	}

	func shouldDisplay(section:Int) -> Bool {
		switch section {
		case 0: return true
		case 1: return vm.currentMilestoneVM != nil
		case 2: return vm.lastUpdateVM != nil
		case 3: return (vm.topCommentsVM?.numberOfItems) ?? 0 != 0
		case 4: return (vm.rewardsVM?.numberOfItems ?? 0) != 0
		default: return false
		}
	}
}

extension CampaignViewController: UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		return [0, 1, 2, 3, 4].reduce(0, { result, value in
			return result + (self.shouldDisplay(section: value) ? 1 : 0)
		})
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0, 1, 2: return (shouldDisplay(section: section) ? 1 : 0)
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
			return cell.setup(with: vm)
		case 1:
			let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.milestoneCell,
													 for: indexPath)!
			if let vm = vm.currentMilestoneVM {
				return cell.setup(with: vm)
			}
		case 2:
			let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.updateCell,
													 for: indexPath)!
			if let vm = vm.lastUpdateVM {
				return cell.setup(with: vm)
			}
		default: break
		}
		return UITableViewCell()
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header = tableView.dequeueReusableHeaderFooterView(
			withIdentifier: R.reuseIdentifier.campaignHeader.identifier) as! CampaignHeader
		switch section {
		case 1: if let vm = vm.currentMilestoneVM { header.setup(with: vm) }
		case 2: if let vm = vm.lastUpdateVM { header.setup(with: vm) }
		case 3: if let vm = vm.topCommentsVM { header.setup(with: vm, for: self.vm) }
		case 4: if let vm = vm.rewardsVM { header.setup(with: vm) }
		default: return nil
		}
		return header.addTap(target: self, action: #selector(headerTap), section: section)
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
		return footer
			.setup(with: title)
			.addTap(target: self, action: #selector(footerTap), section: section)
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if shouldDisplay(section: section) {
			switch section {
			case 1, 2, 3, 4: return 50
			default: break
			}
		}
		return 0
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		if shouldDisplay(section: section) {
			switch section {
			case 0, 1, 2, 3: return 55
			default: break
			}
		}
		return 0
	}
}

extension CampaignViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch (indexPath.row, indexPath.section) {
		default: break
		}
		return
	}

	func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
		return false
	}
}

extension CampaignViewController: ViewModelDelegate {

	func didUpdateData<M>(_ viewModel: ViewModel<M>) where M : Equatable {
		tableView.reloadData()
	}
}

extension UITableViewHeaderFooterView {

	@discardableResult
	func addTap(target: Any, action: Selector, section:Int) -> Self {
		tag = section
		let tap = UITapGestureRecognizer(target: target, action: action)
		addGestureRecognizer(tap)
		return self
	}
}
