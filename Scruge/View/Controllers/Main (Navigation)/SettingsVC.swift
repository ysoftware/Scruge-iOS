//
//  SettingsVC.swift
//  Scruge
//
//  Created by ysoftware on 09/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class SettingsViewController: UIViewController {

	var profileVM:ProfileVM!

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		preferSmallNavbar()
		makeNavbarNormal()
	}

	@IBAction func signOut(_ sender: Any) {
		tabBarController?.selectedIndex = 0
		navigationController?.popViewController(animated: false)
		Service.tokenManager.removeToken()
	}

	@IBAction func editProfile(_ sender:Any) {
		Service.presenter.presentProfileEditViewController(in: self, with: profileVM)
	}
}
