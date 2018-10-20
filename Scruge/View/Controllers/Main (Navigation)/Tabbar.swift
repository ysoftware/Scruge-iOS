//
//  MainTabbar.swift
//  Scruge
//
//  Created by ysoftware on 28/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class TabbarViewController: UITabBarController {

	override func viewDidLoad() {
		super.viewDidLoad()

		viewControllers = Presenter.setupMainTabs()
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

			Presenter.presentAuthViewController(in: self) { didLogIn in
				// select profile tab after successful login
				tabBarController.selectedIndex = 3
			}
			return false
		}
		return true
	}
}
