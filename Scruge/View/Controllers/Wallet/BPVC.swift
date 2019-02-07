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

	@IBOutlet weak var filterField: UITextField!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var voteButton: Button!

	// MARK: - Properties

	private var all:[ProducerVM] = []
	private var filtered:[ProducerVM] = []

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		setupViews()
		setupActions()
		loadList()
	}

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

	private func setupViews() {
		tableView.estimatedRowHeight = 44
		tableView.rowHeight = UITableView.automaticDimension
		tableView.register(UINib(resource: R.nib.bpCell),
						   forCellReuseIdentifier: R.reuseIdentifier.bpCell.identifier)
	}

	private func setupActions() {
		voteButton.addClick(self, action: #selector(send))
	}

	// MARK: - Actions

	@objc func send(_ sender:Any) {

	}

	// MARK: - Methods

	private func updateViews() {
		filterField.text = ""
		filtered = all
		tableView.reloadData()
	}
}

extension VoteBPViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return filtered.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.bpCell, for: indexPath)!
			.setup(with: filtered[indexPath.row])
	}
}

extension VoteBPViewController: UITableViewDelegate {

}
