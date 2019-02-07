//
//  VoteBPVC.swift
//  Scruge
//
//  Created by ysoftware on 07/02/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import UIKit

final class VoteBPViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var passwordField: UITextField!
	@IBOutlet weak var filterField: UITextField!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var voteButton: Button!
	@IBOutlet weak var selectedLabel: UILabel!

	// MARK: - Properties

	var accountVM:AccountVM!

	private var all:[ProducerVM] = []
	private var selected:Set<ProducerVM> = [] {
		didSet {
			updateSelectedCount()
		}
	}

	private var filtered:[ProducerVM] = [] {
		didSet {
			tableView.reloadData()

			for s in selected {
				if let i = filtered.firstIndex(of: s) {
					tableView.selectRow(at: IndexPath(row: i, section: 0),
										animated: true,
										scrollPosition: .none)
				}
			}
		}
	}

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		setupViews()
		setupActions()
		loadList()
		localize()
		setupNavigationBar()
		updateSelectedCount()
	}

	private func setupNavigationBar() {
		navigationController?.navigationBar.isHidden = false
		makeNavbarNormal(with: R.string.localizable.title_vote_bp())
		preferSmallNavbar()
	}

	private func setupViews() {
		filterField.delegate = self

		tableView.estimatedRowHeight = 44
		tableView.rowHeight = UITableView.automaticDimension
		tableView.register(UINib(resource: R.nib.bpCell),
						   forCellReuseIdentifier: R.reuseIdentifier.bpCell.identifier)
	}

	private func setupActions() {
		voteButton.addClick(self, action: #selector(send))
	}

	// MARK: - Actions

	@IBAction func hideKeyboard(_ sender: Any) {
		view.endEditing(true)
	}

	@objc func send(_ sender:Any) {
		view.endEditing(true)

		guard let model = accountVM.model else {
			return alert(GeneralError.implementationError) {
				self.navigationController?.popViewController(animated: true)
			}
		}

		let passcode = passwordField.text ?? ""

		guard passcode.count > 0 else {
			return alert(R.string.localizable.error_wallet_enter_wallet_password())
		}

		Service.eos.voteProducers(from: model,
								  names: Set(selected.compactMap { EosName(from: $0.name) }),
								  passcode: passcode) { result in
			switch result {
			case .success:
				self.alert(R.string.localizable.alert_transaction_success()) {
					self.navigationController?.popViewController(animated: true)
				}
			case .failure(let error):
				self.alert(error)
			}
		}
	}

	// MARK: - Methods

	private func loadList() {
		Service.eos.getProducers { result in
			switch result {
			case .success(let info):
				self.all = info.rows.map { ProducerVM($0, info.totalProducerVoteWeight) }
				self.updateViews()

			case .failure(let error):
				self.alert(error) {
					self.navigationController?.popViewController(animated: true)
				}
			}
		}
	}

	private func updateSelectedCount() {
		selectedLabel.text = R.string.localizable.label_selected_bps("\(selected.count)")
	}

	private func updateViews() {
		filterField.text = ""
		filtered = all
	}
}

extension VoteBPViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return filtered.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let vm = filtered[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.bpCell, for: indexPath)!
			.setup(with: vm)
		return cell
	}
}

extension VoteBPViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selected.insert(filtered[indexPath.row])
	}

	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		selected.remove(filtered[indexPath.row])
	}
}

extension VoteBPViewController: UITextFieldDelegate {

	func textField(_ textField: UITextField,
				   shouldChangeCharactersIn range: NSRange,
				   replacementString string: String) -> Bool {

		if let textFieldString = textField.text,
			let swtRange = Swift.Range(range, in: textFieldString) {
			let fullString = textFieldString.replacingCharacters(in: swtRange, with: string)

			if fullString.isBlank {
				filtered = all
			}
			else {
				filtered = all.filter { $0.name.contains(fullString.lowercased()) }
			}
		}
		return true
	}

	func textFieldShouldClear(_ textField: UITextField) -> Bool {
		filtered = all
		return true
	}
}
