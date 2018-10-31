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
		about = 4, faq = 5, technical = 6, documents = 7
	}

	// MARK: - Outlets

	@IBOutlet weak var loadingView: LoadingView!
	@IBOutlet weak var tableView: UITableView!

	@IBOutlet weak var contributeView: UIView!
	@IBOutlet weak var contributeButton: UIButton!
	@IBOutlet weak var contributeViewTopConstraint: NSLayoutConstraint!

	// MARK: - Actions

	private func openSocialPage(_ element:Social) {
		guard let url = URL(string: element.url) else { return }
		Service.presenter.presentSafariViewController(in: self, url: url)
	}

	@IBAction func contribute(_ sender: Any) {
		switch vm.status {
		case .contribute:
			Service.presenter.presentContributeViewController(in: self, with: vm)
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
			Service.presenter.presentContentViewController(in: self, for: vm)
		case .milestone:
			Service.presenter.presentMilestonesViewController(in: self, for: vm)
		case .update:
			Service.presenter.presentUpdatesViewController(in: self, for: vm)
		case .comments:
			Service.presenter.presentCommentsViewController(in: self, for: vm)
		case .documents:
			Service.presenter.presentDocumentsViewController(in: self, with: vm)
		case .faq:
			Service.presenter.presentFaqViewController(in: self, with: vm)
		case .about:
			Service.presenter.presentTeamViewController(in: self, for: vm)
		default: break
		}
	}

	// MARK: - Properties

	var vm:CampaignVM!

	private let MAX_ELEMENTS = 3

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		setupVM()
		setupTableView()
		setupNavigationBar()
	}

	private func setupVM() {
		vm.delegate = self
		vm.load()
	}

	private func setupTableView() {
		tableView.refreshControl = UIRefreshControl()
		tableView.refreshControl!.addTarget(self, action: #selector(reloadData), for: .valueChanged)

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

	private func setupNavigationBar() {
		let title = vm.isSubscribed ? "Unsubscribe" : "Subscribe"
		let subscribeButton = UIBarButtonItem(title: title,
											  style: .plain,
											  target: self,
											  action: #selector(toggleSubscription))
		navigationItem.rightBarButtonItem = subscribeButton
	}

	private func setupBottomButton() {
		switch vm.status {
		case .idle:
			showContributeButton(false, duration: 0)
		case .voteMilestone, .voteDeadline:
			showContributeButton(true, duration: 0)
			contributeView.backgroundColor = Service.constants.color.contributeBlue
			contributeButton.setTitle("Vote", for: .normal)
		case .contribute:
			showContributeButton(true, duration: 0)
			contributeView.backgroundColor = Service.constants.color.contributeGreen
			contributeButton.setTitle("Contribute", for: .normal)
		}
	}

	private func block(for section:Int) -> Block {
		return Block(rawValue: section)!
	}

	private func shouldDisplay(_ block:Block) -> Bool {
		switch block {
		case .info, .comments, .about: return true
		case .milestone: return vm.currentMilestoneVM != nil
		case .update: return vm.lastUpdateVM != nil
		case .documents: return (vm.documentsVM?.numberOfItems) ?? 0 != 0
		case .faq: return (vm.faqVM?.numberOfItems) ?? 0 != 0
		case .technical: return (vm.technicalVM?.numberOfItems ?? 0) != 0
		}
	}

	private func shouldDisplayHeader(_ block:Block) -> Bool {
		guard shouldDisplay(block) else { return false }

		switch block {
		case .milestone, .update, .comments, .documents, .about, .technical, .faq: return true
		case .info: return false
		}
	}

	private func shouldDisplayFooter(_ block:Block) -> Bool {
		guard shouldDisplay(block) else { return false }

		switch block {
		case .documents:
			return vm.documentsVM?.numberOfItems ?? 0 > MAX_ELEMENTS
		case .faq:
			return vm.faqVM?.numberOfItems ?? 0 > MAX_ELEMENTS
		case .info, .milestone, .about, .update, .comments: return true
		case .technical: return false
		}
	}

	// MARK: - Methods

	@objc func toggleSubscription() {
		vm.toggleSubscribing()
	}

	@objc func reloadData() {
		vm.reloadData()
	}

	private func showData() {
		vm.lastUpdateVM?.delegate = self
		vm.currentMilestoneVM?.delegate = self
		vm.topCommentsVM?.delegate = self
		vm.technicalVM?.delegate = self

		tableView.reloadData()
		setupBottomButton()
	}

	private func showContributeButton(_ visible:Bool = true, duration:TimeInterval = 0.25) {
		var offset:CGFloat = 50
		if #available(iOS 11, *) { offset += view.safeAreaInsets.bottom }
		contributeViewTopConstraint.constant = visible ? offset : 0

		UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
			self.view.layoutSubviews()
		})
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
		case .technical:
			return vm.technicalVM?.numberOfItems ?? 0
		case .faq:
			return min(MAX_ELEMENTS, vm.faqVM?.numberOfItems ?? 0)
		case .documents:
			return min(MAX_ELEMENTS, vm.documentsVM?.numberOfItems ?? 0)
		}
	}

	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
		case .technical:
			if let vm = vm.technicalVM?.item(at: indexPath.row) {
				cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.faqCell,
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
				else {
					header?.setup(as: "Comments", "0")
				}
			case .technical:
				if let vm = vm.technicalVM, vm.numberOfItems > 0 { header?.setup(with: vm) }
			case .about:
				header?.setup(as: "About the team")
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
				if vm.commentsCount > MAX_ELEMENTS {
					title = "See all comments →"
				}
				else {
					title = "Add your comment →"
				}
			case .documents:
				title = "See all documents →"
			case .faq:
				title = "See all answers →"
			case .about:
				title = "Meet the team →"
			default: footer = nil
			}
		}
		return footer?
			.setup(with: title)
			.addTap(target: self, action: #selector(footerTap), section: section)
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		let b = block(for: section)
		if shouldDisplayHeader(b) {
			return 50
		}
		return .leastNormalMagnitude
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		let b = block(for: section)
		if shouldDisplayFooter(b) {
			return 55
		}
		return .leastNormalMagnitude
	}
}

extension CampaignViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		let b = block(for: indexPath.section)
		switch b {
		case .documents:
			guard let url = vm.documentsVM?.item(at: indexPath.row).documentUrl else { return }
			Service.presenter.presentSafariViewController(in: self, url: url)
		case .update:
			guard let vm = vm.lastUpdateVM else { return }
			Service.presenter.presentContentViewController(in: self, for: vm)
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
			loadingView.set(state: .loading)
		case .error(let message):
			loadingView.set(state: .error(message))
			tableView.refreshControl?.endRefreshing()
		case .ready:
			showData()
			loadingView.set(state: .ready)
			tableView.refreshControl?.endRefreshing()
		}
	}
}

extension CampaignViewController: ArrayViewModelDelegate {

	func didUpdateData<M, VM, Q>(_ arrayViewModel: ArrayViewModel<M, VM, Q>, _ update: MVVM.Update)
		where M : Equatable, VM : ViewModel<M>, Q : Query {
			self.tableView.reloadData()
			self.setupNavigationBar()
	}
}
