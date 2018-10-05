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

	@IBOutlet weak var loadingView: LoadingView!
	@IBOutlet weak var tableView: UITableView!

	@IBOutlet weak var contributeView: UIView!
	@IBOutlet weak var contributeButton: UIButton!
	@IBOutlet weak var contributeViewTopConstraint: NSLayoutConstraint!

	// MARK: - Actions
	
	@IBAction func contribute(_ sender: Any) {
		switch vm.status {
		case .contribute:
			let sectionForRewards = numberOfSections() - 1
			tableView.scrollToRow(at: IndexPath(row: 0, section: sectionForRewards),
									   at: .top, animated: true)
			DispatchQueue.main.asyncAfter(deadline: .now() + ANIMATION_TIME) {
				self.tableView.reloadData()
			}
		default: break
		}
	}

	@objc
	func headerTap(_ tap:UITapGestureRecognizer) {
	}

	@objc
	func footerTap(_ tap:UITapGestureRecognizer) {
		switch tap.view!.tag {
		case 0:
			Presenter.presentCampaignHTMLViewController(in: self, for: vm)
		case 1:
			Presenter.presentMilestonesViewController(in: self, for: vm)
		case 2:
			Presenter.presentUpdatesViewController(in: self, for: vm)
		case 3:
			Presenter.presentCommentsViewController(in: self, for: vm)
		default: break
		}
	}

	// MARK: - Properties

	var vm:CampaignVM!
	private var isShowingContributeButton = true
	private let ANIMATION_TIME = 0.25

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		setupVM()
		setupTableView()
	}

	private func setupVM() {
		vm.delegate = self
		vm.load()
	}

	private func setupTableView() {
		tableView.delaysContentTouches = false
		tableView.estimatedRowHeight = 400
		tableView.rowHeight = UITableView.automaticDimension

		tableView.registerHeaderFooterView(R.nib.campHeader)
		tableView.registerHeaderFooterView(R.nib.campFooter)
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
	}

	private func setupBottomButton() {
		switch vm.status {
		case .none:
			contributeView.isHidden = true
		case .vote:
			contributeView.isHidden = false
			contributeView.backgroundColor = Service.constants.color.contributeBlue
			contributeButton.setTitle("Vote", for: .normal)
		case .contribute:
			contributeView.isHidden = false
			contributeView.backgroundColor = Service.constants.color.contributeGreen
			contributeButton.setTitle("Contribute", for: .normal)
		}
	}

	private func shouldDisplay(section:Int) -> Bool {
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

	private func showData() {
		vm.lastUpdateVM?.delegate = self
		vm.currentMilestoneVM?.delegate = self
		vm.topCommentsVM?.delegate = self
		vm.rewardsVM?.delegate = self

		tableView.reloadData()
		setupBottomButton()
	}

	private func numberOfSections() -> Int {
		return [0, 1, 2, 3, 4].reduce(0, { result, value in
			return result + (self.shouldDisplay(section: value) ? 1 : 0)
		})
	}

	private func showContributeButtonIfNeeded() {
		switch vm.status {
		case .contribute:
			let section = numberOfSections() - 1
			let indexPath = IndexPath(row: 0, section: section)
			let isHidden = tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false
			showContributeButton(!isHidden)
		default:
			showContributeButton(false)
		}
	}

	private func showContributeButton(_ visible:Bool = true) {
		guard visible != isShowingContributeButton else { return }
		isShowingContributeButton = visible

		var offset:CGFloat = 50
		if #available(iOS 11, *) { offset += view.safeAreaInsets.bottom }
		contributeViewTopConstraint.constant = visible ? offset : 0

		UIView.animate(withDuration: ANIMATION_TIME, delay: 0, options: .curveEaseInOut, animations: {
			self.view.layoutSubviews()
		})
	}
}

extension CampaignViewController: UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		return numberOfSections()
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
		showContributeButtonIfNeeded()

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
		guard viewModel === vm else {
			tableView.reloadData()
			return
		}

		switch self.vm.state {
		case .loading:
			self.loadingView.set(state: .loading)
		case .error(let message):
			self.loadingView.set(state: .error(message))
		case .ready:
			self.showData()
			self.loadingView.set(state: .ready)
		}
	}
}

extension CampaignViewController: ArrayViewModelDelegate {

	func didUpdateData<M, VM, Q>(_ arrayViewModel: ArrayViewModel<M, VM, Q>, _ update: MVVM.Update)
		where M : Equatable, VM : ViewModel<M>, Q : Query {
			self.tableView.reloadData()
	}
}
