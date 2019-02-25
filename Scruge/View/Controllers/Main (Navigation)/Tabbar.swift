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

		localize()
		Service.presenter.setupMainTabs(in: self)
		tabBar.tintColor = Service.constants.color.purple
		delegate = self

		checkApiVersion()
	}

	private func checkApiVersion() {
		DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
			Service.api.getInfo { result in
				if let response = result.value, let v = response.apiMinSupportVersion, v > Api.version {
					self.alert(R.string.localizable.alert_update_required())
				}
			}
		}
	}
}

extension TabbarViewController: UITabBarControllerDelegate {

	func tabBarController(_ tabBarController: UITabBarController,
						  shouldSelect viewController: UIViewController) -> Bool {

		// if opening profile but not logged in yet
		if let nav = viewController as? UINavigationController,
			nav.topViewController is ProfileViewController,
			!Service.tokenManager.hasToken {

			Service.presenter.presentLoginViewController(in: self) { didLogIn in
				if didLogIn {
					tabBarController.selectedIndex = 4
				}
			}
			return false
		}
		return true
	}
}
