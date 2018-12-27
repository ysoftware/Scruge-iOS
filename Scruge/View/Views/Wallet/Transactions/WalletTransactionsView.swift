//
//  WalletTransactionsView.swift
//  Scruge
//
//  Created by ysoftware on 27/12/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class WalletTransactionsView: UIView {

	private let tableView = UITableView(frame: .zero)
	var vm:ActionsAVM?

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}

	private func setup() {
		addSubview(tableView)
		tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

		tableView.delegate = self
		tableView.dataSource = self
	}
}

extension WalletTransactionsView: UITableViewDelegate {

}

extension WalletTransactionsView: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return vm?.numberOfItems ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
}
