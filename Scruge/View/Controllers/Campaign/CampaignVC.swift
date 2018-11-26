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

	enum Block:Int, CaseIterable {

		case info = 0, economies = 1, update = 2, comments = 3,
		about = 4, faq = 5,  milestone = 6, documents = 7
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
		case .funding:
			if Service.tokenManager.hasToken {
				Service.presenter.presentContributeViewController(in: self, with: vm)
			}
			else {
				Service.presenter.presentAuthViewController(in: self) { isLoggedIn in
					self.vm.reloadData()
				}
			}
		case .activeVote:
			if vm.canVote == true {
				Service.presenter.presentVoteViewController(in: self, with: vm)
			}
		default: break
		}
	}

	// MARK: - Properties

	var vm:CampaignVM!

	private let MAX_ELEMENTS = 3

	// MARK: - Setup

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		setupVM()
		setupTableView()
		setupNavigationBar()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		if vm.state == .ready {
			setupBottomButton()
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		makeNavigationBarTransparent()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		makeNavigationBarNormal()
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

		// make table view go under the navigation bar
		if #available(iOS 11.0, *) {
			tableView.contentInsetAdjustmentBehavior = .never
		}
		automaticallyAdjustsScrollViewInsets = false

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
		tableView.register(UINib(resource: R.nib.economiesCell),
						   forCellReuseIdentifier: R.reuseIdentifier.economiesCell.identifier)
		tableView.register(UINib(resource: R.nib.pagingCell),
						   forCellReuseIdentifier: R.reuseIdentifier.pagingCell.identifier)
	}

	private func setupNavigationBar() {
		if let isSubscribed = vm.isSubscribed {
			let title = isSubscribed ? "Unsubscribe" : "Subscribe"
			let subscribeButton = UIBarButtonItem(title: title,
												  style: .plain,
												  target: self,
												  action: #selector(toggleSubscription))
			navigationItem.rightBarButtonItem = subscribeButton
		}
		else {
			navigationItem.rightBarButtonItem = nil
		}
	}

	private func makeNavigationBarTransparent() {
		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationController?.navigationBar.shadowImage = UIImage()
		navigationController?.navigationBar.tintColor = .white
		title = ""
	}

	private func makeNavigationBarNormal() {
		navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
		navigationController?.navigationBar.shadowImage = nil
		navigationController?.navigationBar.tintColor = view.tintColor
		title = vm.title
	}

	private func setupBottomButton() {
		switch vm.status {
		case .activeVote:
			showContributeButton(true, duration: 0)
			if vm.canVote == true {
				contributeView.backgroundColor = Service.constants.color.contributeBlue
				contributeButton.setTitle("Vote", for: .normal)
			}
			else {
				contributeView.backgroundColor = Service.constants.color.contributeBlue
				contributeButton.setTitle("You already voted", for: .normal)
			}
		case .funding:
			if Service.tokenManager.hasToken {
				showContributeButton(true, duration: 0)
				contributeView.backgroundColor = Service.constants.color.contributeGreen
				contributeButton.setTitle("Contribute", for: .normal)
			}
			else {
				showContributeButton(true, duration: 0)
				contributeView.backgroundColor = Service.constants.color.contributeGreen
				contributeButton.setTitle("Sign in to contribute", for: .normal)
			}
		default:
			showContributeButton(false, duration: 0)
		}
	}

	private func block(for row:Int) -> Block {
		for i in row..<Block.allCases.count {
			let block = Block(rawValue: i)!
			if shouldDisplay(block) {
				return block
			}
		}
		return Block(rawValue: row)!
	}

	private func shouldDisplay(_ block:Block) -> Bool {
		switch block {
		case .info, .comments, .about: return true
		case .milestone: return vm.currentMilestoneVM != nil
		case .update: return vm.lastUpdateVM != nil
		case .economies: return vm.economiesVM != nil
		case .documents: return (vm.documentsVM?.numberOfItems) ?? 0 != 0
		case .faq: return (vm.faqVM?.numberOfItems) ?? 0 != 0
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
		vm.economiesVM?.delegate = self
		vm.milestonesVM?.delegate = self

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

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Block.allCases.filter { shouldDisplay($0) }.count
	}

	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell:UITableViewCell!
		switch block(for: indexPath.row) {
		case .about:
			cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.aboutCell,
												 for: indexPath)!.setup(with: vm) { social in
													self.openSocialPage(social)
			}
		case .info:
			cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.campaignCell,
												 for: indexPath)!.setup(with: vm)
		case .economies:
			guard let vm = vm.economiesVM else { break }
			cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.economiesCell,
												 for: indexPath)!.setup(with: vm)
		case .faq:
			guard let vm = vm.faqVM else { break }
			cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.pagingCell,
												 for: indexPath)!.setup(with: vm) { index in
													// open faq
			}
		case .milestone:
			guard let vm = vm.milestonesVM, let cvm = self.vm.currentMilestoneVM else { break }
			cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.pagingCell,
												 for: indexPath)!.setup(with: vm, cvm) { index in
													// open milestone?
			}
		case .update:
			guard let vm = vm.lastUpdateVM else { break }
			cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.updateCell,
												 for: indexPath)!.setup(with: vm)
		default: break
		}
		if cell == nil { cell = UITableViewCell() }
		cell.selectionStyle = .none
		return cell
	}
}

extension CampaignViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

	}
}

extension CampaignViewController: ViewModelDelegate {

	func didUpdateData<M>(_ viewModel: ViewModel<M>) where M : Equatable {
		guard viewModel === vm else {
			tableView.reloadData()
			return
		}

		loadingView.set(state: vm.state)

		switch self.vm.state {
		case .error:
			tableView.refreshControl?.endRefreshing()
		case .ready:
			showData()
			tableView.refreshControl?.endRefreshing()
		case .loading: break
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

extension CampaignViewController: UIScrollViewDelegate {

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView.contentOffset.y > 350 {
			makeNavigationBarNormal()
		}
		else {
			makeNavigationBarTransparent()
		}
	}
}
