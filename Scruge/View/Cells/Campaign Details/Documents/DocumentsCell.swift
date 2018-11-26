//
//  DocumentsCell.swift
//  Scruge
//
//  Created by ysoftware on 26/11/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class DocumentsCell: UITableViewCell {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!

	private var vm:DocumentAVM!

	@discardableResult
	func setup(with vm:DocumentAVM) -> DocumentsCell {
		self.vm = vm
		tableView.register(UINib(resource: R.nib.documentCell),
						   forCellReuseIdentifier: R.reuseIdentifier.documentCell.identifier)
		tableView.reloadData()
		tableViewHeightConstraint.constant = tableView.contentSize.height
		layoutSubviews()
		return self
	}
}

extension DocumentsCell: UITableViewDataSource {

	func tableView(_ tableView: UITableView,
				   numberOfRowsInSection section: Int) -> Int {
		return vm.numberOfItems
	}

	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.documentCell,
											 for: indexPath)!.setup(with: vm.item(at: indexPath.row))
	}
}

extension DocumentsCell: UITableViewDelegate {

}
