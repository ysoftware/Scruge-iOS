//
//  VoteVC.swift
//  Scruge
//
//  Created by ysoftware on 15/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class VoteViewController: UIViewController {

	private enum Block:Int, CaseIterable {

		case info = 0, update = 1, milestone = 2, countdown = 3, controls = 4
	}

	@IBOutlet weak var tableView: UITableView!

	// MARK: - Properties

	private let NAVBAR_LIMIT:CGFloat = 240
	var vm:CampaignVM!
	private var voting:VoteInfo?
	private let accountVM = AccountAVM()
	private var updateVM = UpdateVM()

	var offset:CGFloat = 0 {
		didSet {
			setNeedsStatusBarAppearanceUpdate()
			if offset > NAVBAR_LIMIT {
				preferSmallNavbar()
				makeNavbarNormal(with: vm.title, tint: view.tintColor)
			}
			else {
				preferSmallNavbar()
				makeNavbarTransparent()
			}
		}
	}

	// MARK: - Setup

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return offset > NAVBAR_LIMIT ? .default : .lightContent
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		setupVM()
		setupKeyboard()
		setupTable()
		loadVote()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if offset < NAVBAR_LIMIT {
			preferSmallNavbar()
			makeNavbarTransparent()
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		makeNavbarNormal()
	}

	private func setupVM() {
		accountVM.reloadData()
	}

	private func loadVote() {
		vm.loadVoteInfo { voting in
			self.voting = voting
			self.tableView.reloadData()
		}
	}

	private func setupKeyboard() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
											   name:UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
											   name:UIResponder.keyboardWillHideNotification, object: nil)
	}

	private func setupTable() {
//		 make table view go under the navigation bar
		if #available(iOS 11.0, *) {
			tableView.contentInsetAdjustmentBehavior = .never
		}
		automaticallyAdjustsScrollViewInsets = false

		tableView.delaysContentTouches = false
		tableView.estimatedRowHeight = 100
		tableView.rowHeight = UITableView.automaticDimension

		tableView.register(UINib(resource: R.nib.voteInfoCell),
						   forCellReuseIdentifier: R.reuseIdentifier.voteInfoCell.identifier)
		tableView.register(UINib(resource: R.nib.countdownCell),
						   forCellReuseIdentifier: R.reuseIdentifier.countdownCell.identifier)
		tableView.register(UINib(resource: R.nib.lastUpdateCell),
						   forCellReuseIdentifier: R.reuseIdentifier.lastUpdateCell.identifier)
		tableView.register(UINib(resource: R.nib.pagingCell),
						   forCellReuseIdentifier: R.reuseIdentifier.pagingCell.identifier)
		tableView.register(UINib(resource: R.nib.voteControlsCell),
						   forCellReuseIdentifier: R.reuseIdentifier.voteControlsCell.identifier)
	}

	// MARK: - Actions

	@IBAction func hideKeyboard(_ sender: Any) {
		view.endEditing(true)
	}

	private func vote(_ value:Bool, _ passcode:String) {
		guard let account = accountVM.selectedAccount else {
			#warning("check if maybe should open wallet picker right there?")
			return alert("You don't have your blockchain account setup")
		}

		guard passcode.count > 0 else {
			return alert("Enter your wallet passcode")
		}

		self.vm.vote(value, account: account, passcode: passcode) { error in
			if let error = error {
				self.alert(error)
			}
			else {
				self.alert("Transaction was successful.") {
					self.navigationController?.popViewController(animated: true)
				}
			}
		}
	}
}

extension VoteViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Block.allCases.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell:UITableViewCell!
		switch Block(rawValue: indexPath.row)! {
		case .update:
			cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.lastUpdateCell,
												 for: indexPath)!.setup(with: updateVM, title: "Rationale: ")
				.updateTap { [unowned self] in
					Service.presenter.presentContentViewController(in: self, for: self.updateVM)
				}
		case .info:
			guard let voting = self.voting else { break }
			cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.voteInfoCell,
												 for: indexPath)!.setup(with: vm, kind: voting.kind)
		case .countdown:
			guard let voting = self.voting else { break }
			cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.countdownCell,
												 for: indexPath)!
				.setup(title: "This vote ends in:", timestamp: voting.endTimestamp)
		case .controls:
			cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.voteControlsCell,
												 for: indexPath)!
				.vote { [unowned self] passcode, value in
					self.vote(value, passcode)
				}
		case .milestone:
			guard let vm = vm.milestonesVM, let cvm = self.vm.currentMilestoneVM else { break }
			cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.pagingCell,
												 for: indexPath)!.setup(with: vm, cvm)
				.tap { [unowned self] index in } // open milestone?
		default: break
		}
		if cell == nil { cell = UITableViewCell() }
		return cell
	}
}

extension VoteViewController {

	@objc func keyboardWillShow(notification:NSNotification) {
		guard let userInfo = notification.userInfo else { return }
		let keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
		let convertedFrame = view.convert(keyboardFrame, from: nil)
		tableView.contentInset.bottom = convertedFrame.size.height
		tableView.scrollIndicatorInsets.bottom = convertedFrame.size.height
	}

	@objc func keyboardWillHide(notification:NSNotification) {
		tableView.contentInset.bottom = 0
	}
}

extension VoteViewController: UITableViewDelegate {

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		offset = scrollView.contentOffset.y
	}
}
