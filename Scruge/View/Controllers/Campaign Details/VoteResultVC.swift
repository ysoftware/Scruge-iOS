//
//  VoteResultVC.swift
//  Scruge
//
//  Created by ysoftware on 30/11/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class VoteResultsViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!

	var vm:CampaignVM!

	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
	}

	private func setupView() {
		vm.loadVoteResults { result in
			guard let result = result else {
				self.navigationController?.popViewController(animated: true)
				return
			}

			
		}
	}
}
