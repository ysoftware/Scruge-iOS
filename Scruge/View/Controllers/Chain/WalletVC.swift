//
//  WalletVC.swift
//  Scruge
//
//  Created by ysoftware on 17/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class WalletViewController: UIViewController {

	override func viewDidLoad() {

		Service.eos.sendMoney()
	}
}
