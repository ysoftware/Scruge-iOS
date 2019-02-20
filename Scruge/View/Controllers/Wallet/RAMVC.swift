//
//  RAMVC.swift
//  Scruge
//
//  Created by ysoftware on 20/02/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import UIKit
import MVVM

final class RAMViewController: UIViewController {

	private enum Action: CaseIterable {

		case buyBytes, buyEOS, sell

		var label:String {
			switch self {
			case .sell: return R.string.localizable.label_sell_ram()
			case .buyBytes: return R.string.localizable.label_buy_ram_bytes()
			case .buyEOS: return R.string.localizable.label_buy_ram_eos()
			}
		}
	}

	// MARK: - Outlets

	@IBOutlet weak var pickerField: UITextField!
	@IBOutlet weak var resourcesView: ResourcesView!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var button: Button!
	@IBOutlet weak var amountField: FormTextField!
	@IBOutlet weak var passwordField: UITextField!

	// MARK: - Properties

	var accountVM:AccountVM!

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		localize()
		setupViews()
		setupActions()
		setupNavigationBar()
	}

	private func setupNavigationBar() {
		navigationController?.navigationBar.isHidden = false
		makeNavbarNormal(with: R.string.localizable.title_manage_ram())
		preferSmallNavbar()
	}

	private func setupViews() {
		resourcesView.accountName = accountVM.name
		pickerField.placeholder = Action.allCases.first?.label

		Service.eos.getRAMPrice { result in
			switch result {
			case .success(let value):
				let price = (value * 1024).formatRounding(to: 4, min: 4)
				self.priceLabel.text = R.string.localizable.current_ram_price(price)
			case .failure(let error):
				self.priceLabel.text = ErrorHandler.message(for: error)
			}
			self.updateViews()
		}
	}

	private func setupActions() {

	}

	// MARK: - Actions

	@IBAction func pickerTapped(_ sender: Any) {
		let title = R.string.localizable.title_select_action()
		let actions = Action.allCases.map { $0.label }

		Service.presenter.presentPickerController(in: self, with: actions, andTitle: title) { position in

		}
	}
	
	// MARK: - Methods

	private func updateViews() {

	}
}
