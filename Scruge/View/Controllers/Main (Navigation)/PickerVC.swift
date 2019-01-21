//
//  PickerVC.swift
//  Scruge
//
//  Created by ysoftware on 21/01/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import UIKit

final class PickerViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var pickerView: UIPickerView!
	@IBOutlet weak var button: Button!
	
	// MARK: - Properties

	var titleText:String?
	var block:((Int?)->Void)!
	var items:[String]!

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		setupViews()
		setupActions()
	}

	private func setupViews() {
		titleLabel.text = titleText?.uppercased()
		titleLabel.isHidden = titleText == nil
		pickerView.dataSource = self
		pickerView.delegate = self
		pickerView.reloadAllComponents()
	}

	private func setupActions() {
		button.addTargetClosure { [unowned self] _ in
			self.dismiss(animated: true) {
				self.block?(self.pickerView.selectedRow(inComponent: 0))
			}
		}
	}

	@IBAction func viewTapped(_ sender: Any) {
		self.dismiss(animated: true) {
			self.block?(nil)
		}
	}
}

extension PickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView,
					titleForRow row: Int,
					forComponent component: Int) -> String? {
		return items[row]
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return items.count
	}
}
