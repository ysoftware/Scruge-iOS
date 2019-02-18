//
//  SubmitVC.swift
//  Scruge
//
//  Created by ysoftware on 18/02/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import UIKit

final class SubmitViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var proofField: UITextField!
	@IBOutlet weak var passcodeField: UITextField!
	@IBOutlet weak var button: Button!

	// MARK: - Properties

	var accountAVM = AccountAVM()
	var bountyVM:BountyVM!
	var projectVM:ProjectVM!

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		localize()
		setupNavigationBar()
		setupActions()
		setupVM()
	}

	private func setupVM() {
		accountAVM.reloadData()
	}

	private func setupNavigationBar() {
		preferSmallNavbar()
	}

	private func setupActions() {
		button.addClick(self, action: #selector(send))
	}

	// MARK: - Actions

	@objc func send(_ sender:Any) {
		guard let id = bountyVM.id, let providerName = projectVM?.providerName else {
			return alert(GeneralError.implementationError)
		}

		guard let passcode = passcodeField.text, passcode.isNotBlank else {
			return alert(R.string.localizable.error_wallet_enter_wallet_password())
		}

		guard let proof = proofField.text, proof.isNotBlank else {
			return alert(R.string.localizable.error_enter_proof())
		}

		guard let vm = accountAVM.selectedAccount, let model = vm.model else { return }

		Service.eos
			.bountySubmit(from: model,
						  proof: proof,
						  providerName: providerName,
						  bountyId: id,
						  passcode: passcode) { result in
				switch result {
				case .success(_):
					Service.api
						.postSubmission(bountyId: id,
										proof: proof,
										hunterName: model.name,
										providerName: providerName) { _ in
							self.alert(R.string.localizable.alert_transaction_success()) {
								self.navigationController?.popViewController(animated: true)
							}
					}
				case .failure(let error):
					self.alert(error)
				}
		}
	}
}

