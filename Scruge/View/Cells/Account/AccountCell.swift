//
//  AccountCell.swift
//  Scruge
//
//  Created by ysoftware on 19/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import MVVM

final class AccountCell: UITableViewCell {

	@IBOutlet weak var nameLabel:UILabel!
	@IBOutlet weak var balanceLabel:UILabel!

	@IBOutlet weak var checkboxView: RoundedView!
	@IBOutlet weak var checkboxImage: UIImageView!

	@discardableResult
	func setup(with vm:AccountVM) -> Self {
		vm.delegate = self
		vm.updateBalance()
		return self
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		checkboxView.backgroundColor = selected ? Service.constants.color.purple : .white
		checkboxImage.isHidden = !selected
	}
}

extension AccountCell: ViewModelDelegate {

	func didUpdateData<M>(_ viewModel: ViewModel<M>) where M : Equatable {
		guard let vm = viewModel as? AccountVM else { return }

		nameLabel.text = vm.displayName
		balanceLabel.text = "" // vm.balanceString(", ")
	}
}
