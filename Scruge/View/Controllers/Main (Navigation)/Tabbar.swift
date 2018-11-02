//
//  MainTabbar.swift
//  Scruge
//
//  Created by ysoftware on 28/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import MVVM

final class TabbarViewController: UITabBarController {

	override func viewDidLoad() {
		super.viewDidLoad()

		viewControllers = Service.presenter.setupMainTabs()
		delegate = self
	}
}

extension TabbarViewController: UITabBarControllerDelegate {

	func tabBarController(_ tabBarController: UITabBarController,
						  shouldSelect viewController: UIViewController) -> Bool {

		// if opening profile but not logged in yet
		if let nav = viewController as? UINavigationController,
			nav.topViewController is ProfileViewController,
			Service.tokenManager.getToken() == nil {

			Service.presenter.presentAuthViewController(in: self) { didLogIn in
				if didLogIn {
					tabBarController.selectedIndex = 3
				}
			}
			return false
		}
		return true
	}
}
