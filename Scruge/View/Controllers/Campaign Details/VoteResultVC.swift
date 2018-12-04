//
//  VoteResultVC.swift
//  Scruge
//
//  Created by ysoftware on 30/11/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class VoteResultsViewController: UIViewController {

	private enum Block:Int, CaseIterable {

		case info = 0, result = 1, countdown = 2
	}

	@IBOutlet weak var tableView: UITableView!

	// MARK: - Properties

	private let NAVBAR_LIMIT:CGFloat = 240
	var vm:CampaignVM!
	private var result:VoteResult?
	private let accountVM = AccountAVM()

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

		loadResult()
		setupVM()
		setupTable()
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

	private func loadResult() {
		vm.loadVoteResults { result in
			self.result = result
			self.tableView.reloadData()
		}
	}

	private func setupTable() {
		if #available(iOS 11.0, *) {
			tableView.contentInsetAdjustmentBehavior = .never
			tableView.contentInset.top = -35
		}
		automaticallyAdjustsScrollViewInsets = false

		tableView.delaysContentTouches = false
		tableView.estimatedRowHeight = 150
		tableView.rowHeight = UITableView.automaticDimension

		tableView.register(UINib(resource: R.nib.voteInfoCell),
						   forCellReuseIdentifier: R.reuseIdentifier.voteInfoCell.identifier)
		tableView.register(UINib(resource: R.nib.countdownCell),
						   forCellReuseIdentifier: R.reuseIdentifier.countdownCell.identifier)
		tableView.register(UINib(resource: R.nib.voteResultCell),
						   forCellReuseIdentifier: R.reuseIdentifier.voteResultCell.identifier)
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

extension VoteResultsViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Block.allCases.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell:UITableViewCell!
		switch Block(rawValue: indexPath.row)! {
		case .info:
			guard let kind = result?.kind else { break }
			cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.voteInfoCell,
												 for: indexPath)!.setup(with: vm, kind: kind)
		case .countdown:
			cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.countdownCell,
												 for: indexPath)!
				.setup(title: "This vote ends in:", timestamp: 0)
		case .result:
			guard let result = result else { break }
			cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.voteResultCell,
												 for: indexPath)!
				.setup(with: result)
		}
		if cell == nil { cell = UITableViewCell() }
		return cell
	}
}

extension VoteResultsViewController: UITableViewDelegate {

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		offset = scrollView.contentOffset.y
	}
}
