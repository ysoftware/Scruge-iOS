//
//  CampaignVC.swift
//  Scruge
//
//  Created by ysoftware on 01/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import MVVM
import SafariServices

final class CampaignViewController: UIViewController {

	enum Block:Int {

		case info = 0, milestone = 1, update = 2, comments = 3,
		about = 4, faq = 5, documents = 6, rewards = 7
	}

	// MARK: - Outlets

	@IBOutlet weak var loadingView: LoadingView!
	@IBOutlet weak var tableView: UITableView!

	@IBOutlet weak var contributeView: UIView!
	@IBOutlet weak var contributeButton: UIButton!
	@IBOutlet weak var contributeViewTopConstraint: NSLayoutConstraint!

	// MARK: - Actions

	private func openSocialPage(_ element:SocialElement) {
		guard let url = URL(string: element.url) else { return }
		Presenter.presentSafariViewController(in: self, url: url)
	}

	@IBAction func contribute(_ sender: Any) {
		switch vm.status {
		case .contribute:
			if shouldDisplay(.rewards) {
				scrollToRewards()
			}
			else {
				Presenter.presentContributeViewController(in: self, with: vm)
			}
		default: break
		}
	}

	@objc
	func headerTap(_ tap:UITapGestureRecognizer) {
		let b = block(for: tap.view!.tag)
		switch b {
		default: break
		}
	}

	@objc
	func footerTap(_ tap:UITapGestureRecognizer) {
		let b = block(for: tap.view!.tag)
		switch b {
		case .info:
			Presenter.presentCampaignHTMLViewController(in: self, for: vm)
		case .milestone:
			Presenter.presentMilestonesViewController(in: self, for: vm)
		case .update:
			Presenter.presentUpdatesViewController(in: self, for: vm)
		case .comments:
			Presenter.presentCommentsViewController(in: self, for: vm)
		case .documents:
			Presenter.presentDocumentsViewController(in: self, with: vm)
		case .faq:
			Presenter.presentFaqViewController(in: self, with: vm)
		default: break
		}
	}

	// MARK: - Properties

	var vm:CampaignVM!
	private var isShowingContributeButton = true

	private let MAX_ELEMENTS = 3
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
		tableView.register(UINib(resource: R.nib.aboutCell),
						   forCellReuseIdentifier: R.reuseIdentifier.aboutCell.identifier)
		tableView.register(UINib(resource: R.nib.faqCell),
						   forCellReuseIdentifier: R.reuseIdentifier.faqCell.identifier)
		tableView.register(UINib(resource: R.nib.documentCell),
						   forCellReuseIdentifier: R.reuseIdentifier.documentCell.identifier)
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

	private func block(for section:Int) -> Block {
		return Block(rawValue: section)!
	}

	private func shouldDisplayFooter(_ block:Block) -> Bool {
		guard shouldDisplay(block) else { return false }

		switch block {
		case .documents:
			return vm.documentsVM?.numberOfItems ?? 0 > MAX_ELEMENTS
		case .faq:
			return vm.faqVM?.numberOfItems ?? 0 > MAX_ELEMENTS
		case .comments:
			return vm.commentsCount > MAX_ELEMENTS
		case .info, .milestone, .update: return true
		case .rewards, .about: return false
		}
	}

	private func shouldDisplay(_ block:Block) -> Bool {
		switch block {
		case .info: return true
		case .milestone: return vm.currentMilestoneVM != nil
		case .update: return vm.lastUpdateVM != nil
		case .about: return vm.about != nil
		case .comments: return (vm.topCommentsVM?.numberOfItems) ?? 0 != 0
		case .documents: return (vm.documentsVM?.numberOfItems) ?? 0 != 0
		case .faq: return (vm.documentsVM?.numberOfItems) ?? 0 != 0
		case .rewards: return (vm.rewardsVM?.numberOfItems ?? 0) != 0
		}
	}

	// MARK: - Methods

	private func showData() {
		vm.lastUpdateVM?.delegate = self
		vm.currentMilestoneVM?.delegate = self
		vm.topCommentsVM?.delegate = self
		vm.rewardsVM?.delegate = self

		tableView.reloadData()
		setupBottomButton()
	}

	private func showContributeButtonIfNeeded() {
		switch vm.status {
		case .contribute:
			guard shouldDisplay(.rewards) else { return showContributeButton(true) }

			let indexPath = IndexPath(row: 0, section: Block.rewards.rawValue)
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

	private func scrollToRewards() {
		tableView.scrollToRow(at: IndexPath(row: 0, section: Block.rewards.rawValue),
							  at: .top, animated: true)
		DispatchQueue.main.asyncAfter(deadline: .now() + ANIMATION_TIME) {
			self.tableView.reloadData()
		}
	}
}

extension CampaignViewController: UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		return 8
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let b = block(for: section)
		switch b {
		case .info, .about, .milestone, .update:
			return (shouldDisplay(b) ? 1 : 0)
		case .comments:
			return min(MAX_ELEMENTS, vm.topCommentsVM?.numberOfItems ?? 0)
		case .rewards:
			return vm.rewardsVM?.numberOfItems ?? 0
		case .faq:
			return min(MAX_ELEMENTS, vm.faqVM?.numberOfItems ?? 0)
		case .documents:
			return min(MAX_ELEMENTS, vm.documentsVM?.numberOfItems ?? 0)
		}
	}

	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		showContributeButtonIfNeeded()

		var cell:UITableViewCell!
		switch block(for: indexPath.section) {
		case .info:
			cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.campaignCell,
												 for: indexPath)!.setup(with: vm)
		case .milestone:
			if let vm = vm.currentMilestoneVM {
				cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.milestoneCell,
													 for: indexPath)!.setup(with: vm)
			}
		case .update:
			if let vm = vm.lastUpdateVM {
				cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.updateCell,
													 for: indexPath)!.setup(with: vm)
			}
		case .about:
			if vm.about != nil || vm.social.count > 0 {
				cell = tableView.dequeueReusableCell(
					withIdentifier: R.reuseIdentifier.aboutCell,
					for: indexPath)!.setup(with: vm) { [unowned self] element in
						self.openSocialPage(element)
				}
			}
		case .comments:
			if let vm = vm.topCommentsVM?.item(at: indexPath.row) {
				cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.commentCell,
													 for: indexPath)!.setup(with: vm)
			}
		case .rewards:
			if let vm = vm.rewardsVM?.item(at: indexPath.row) {
				cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.rewardCell,
													 for: indexPath)!.setup(with: vm)
			}
		case .faq:
			if let vm = vm.faqVM?.item(at: indexPath.row) {
				cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.faqCell,
													 for: indexPath)!.setup(with: vm)
			}
		case .documents:
			if let vm = vm.documentsVM?.item(at: indexPath.row) {
				cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.documentCell,
													 for: indexPath)!.setup(with: vm)
			}
		}
		if cell == nil { cell = UITableViewCell() }
		cell.selectionStyle = .none
		return cell
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		var header = tableView.dequeueReusableHeaderFooterView(
			withIdentifier: R.reuseIdentifier.campaignHeader.identifier) as? CampaignHeader
		let b = block(for: section)
		if shouldDisplay(b) {
			switch b {
			case .milestone:
				if let vm = vm.currentMilestoneVM { header?.setup(with: vm) }
			case .update:
				if let vm = vm.lastUpdateVM { header?.setup(with: vm) }
			case .comments:
				if let vm = vm.topCommentsVM, vm.numberOfItems > 0 { header?.setup(with: vm, for: self.vm) }
			case .rewards:
				if let vm = vm.rewardsVM, vm.numberOfItems > 0 { header?.setup(with: vm) }
			case .about:
				if vm.about != nil { header?.setup(as: "About the team") }
			case .faq:
				if let vm = vm.faqVM, vm.numberOfItems > 0  { header?.setup(with: vm) }
			case .documents:
				if let vm = vm.documentsVM, vm.numberOfItems > 0 { header?.setup(with: vm) }
			default: header = nil
			}
		}
		return header?.addTap(target: self, action: #selector(headerTap), section: section)
	}

	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		var footer = tableView.dequeueReusableHeaderFooterView(
			withIdentifier: R.reuseIdentifier.campaignFooter.identifier) as? CampaignFooter
		var title:String = ""
		let b = block(for: section)
		if shouldDisplayFooter(b) {
			switch b {
			case .info:
				title = "See the pitch →"
			case .milestone:
				title = "See all milestones →"
			case .update:
				title = "See all updates →"
			case .comments:
				title = "See all comments →"
			case .documents:
				title = "See all documents →"
			case .faq:
				title = "See all answers →"
			default: footer = nil
			}
		}
		return footer?
			.setup(with: title)
			.addTap(target: self, action: #selector(footerTap), section: section)
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		let b = block(for: section)
		if shouldDisplay(b) {
			switch b {
			case .milestone, .update, .comments, .documents, .about, .rewards, .faq: return 50
			case .info: break
			}
		}
		return .leastNormalMagnitude
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		let b = block(for: section)
		if shouldDisplayFooter(b) {
			switch b {
			case .info, .milestone, .update, .comments, .documents, .faq: return 55
			case .rewards, .about: break
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
