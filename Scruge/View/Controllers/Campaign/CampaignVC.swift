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

	@IBOutlet weak var errorView: ErrorView!
	@IBOutlet weak var loadingView: UIView!
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
		setupVM()
	}

	func setupVM() {
		vm.delegate = self
		vm.load()
	}

	func setupTableView() {
		tableView.delaysContentTouches = false
		tableView.estimatedRowHeight = 400
		tableView.rowHeight = UITableView.automaticDimension

		tableView.register(UINib(resource: R.nib.campaignCell),
						   forCellReuseIdentifier: R.reuseIdentifier.campaignCell.identifier)
		tableView.register(UINib(resource: R.nib.milestoneCell),
						   forCellReuseIdentifier: R.reuseIdentifier.milestoneCell.identifier)
		tableView.register(UINib(resource: R.nib.updateCell),
						   forCellReuseIdentifier: R.reuseIdentifier.updateCell.identifier)
		tableView.register(UINib(resource: R.nib.commentCell),
						   forCellReuseIdentifier: R.reuseIdentifier.commentCell.identifier)
		tableView.register(UINib(resource: R.nib.rewardCell),
						   forCellReuseIdentifier: R.reuseIdentifier.rewardCell.identifier)
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

	// MARK: - State

	func showView() {
		tableView.isHidden = vm.state != .ready
		loadingView.isHidden = vm.state != .loading
		errorView.isHidden = vm.state != .error("")
	}

	func showData() {
		vm.lastUpdateVM?.delegate = self
		vm.currentMilestoneVM?.delegate = self
		vm.topCommentsVM?.delegate = self
		vm.rewardsVM?.delegate = self

		tableView.reloadData()
		showView()
	}

	func showLoading() {
		showView()
	}

	func showError(_ message:String) {
		showView()
		errorView.set(message: message)
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
		var cell:UITableViewCell!
		switch indexPath.section {
		case 0:
			cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.campaignCell,
												 for: indexPath)!.setup(with: vm)
		case 1:
			if let vm = vm.currentMilestoneVM {
				cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.milestoneCell,
													 for: indexPath)!.setup(with: vm)
			}
		case 2:
			if let vm = vm.lastUpdateVM {
				cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.updateCell,
													 for: indexPath)!.setup(with: vm)
			}
		case 3:
			if let vm = vm.topCommentsVM?.item(at: indexPath.row) {
				cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.commentCell,
													 for: indexPath)!.setup(with: vm)
			}
		case 4:
			if let vm = vm.rewardsVM?.item(at: indexPath.row) {
				cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.rewardCell,
													 for: indexPath)!.setup(with: vm)
			}
		default: break
		}
		if cell == nil { cell = UITableViewCell() }
		cell.selectionStyle = .none
		return cell
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
		return .leastNormalMagnitude
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		if shouldDisplay(section: section) {
			switch section {
			case 0, 1, 2, 3: return 55
			default: break
			}
		}
		return .leastNormalMagnitude
	}
}

extension CampaignViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		switch (indexPath.row, indexPath.section) {
		default: break
		}
		return
	}
}

extension CampaignViewController: ViewModelDelegate {

	func didUpdateData<M>(_ viewModel: ViewModel<M>) where M : Equatable {
		DispatchQueue.main.async {
			if viewModel === self.vm {
				switch self.vm.state {
				case .ready:
					self.showData()
				case .loading:
					self.showLoading()
				case .error(let error):
					self.showError(error)
				}
			}
		}
	}
}

extension CampaignViewController: ArrayViewModelDelegate {

	func didUpdateData<M, VM, Q>(_ arrayViewModel: ArrayViewModel<M, VM, Q>, _ update: MVVM.Update)
		where M : Equatable, VM : ViewModel<M>, Q : Query {
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
	}
}
