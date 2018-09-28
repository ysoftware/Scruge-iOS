//
//  Presenter.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

struct Presenter {

	static func presentAuthViewController(in vc:UIViewController) {
		let new = R.storyboard.main.authVC()!.inNavigationController
		vc.present(new, animated: true)
	}

	static func setupMainTabs() -> [UIViewController] {
		let featured = R.storyboard.main.trendingVC()!.inNavigationController
		featured.tabBarItem = UITabBarItem(title: "Featured", image: nil, tag: 0)

		let activity = R.storyboard.main.activityVC()!.inNavigationController
		activity.tabBarItem = UITabBarItem(title: "Activity", image: nil, tag: 1)

		let search = R.storyboard.main.searchVC()!.inNavigationController
		search.tabBarItem = UITabBarItem(title: "Search", image: nil, tag: 2)

		let profile = R.storyboard.main.profileVC()!.inNavigationController
		profile.tabBarItem = UITabBarItem(title: "Profile", image: nil, tag: 3)

		return [featured, activity, search, profile]
	}
}

fileprivate extension UIViewController {

	var inNavigationController:UINavigationController {
		return UINavigationController(rootViewController: self)
	}
}
