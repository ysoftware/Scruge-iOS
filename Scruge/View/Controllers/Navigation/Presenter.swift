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
		let new = R.storyboard.authProfile.authVC()!.inNavigationController
		vc.present(new, animated: true)
	}

	static func setupMainTabs() -> [UIViewController] {
		let featured = R.storyboard.campaign.featuredVC()!.inNavigationController
		featured.tabBarItem = UITabBarItem(title: "Featured", image: nil, tag: 0)
 
		let activity = R.storyboard.updMilRew.activityVC()!.inNavigationController
		activity.tabBarItem = UITabBarItem(title: "Activity", image: nil, tag: 1)

		let search = R.storyboard.campaign.searchVC()!.inNavigationController
		search.tabBarItem = UITabBarItem(title: "Search", image: nil, tag: 2)

		let profile = R.storyboard.authProfile.profileVC()!.inNavigationController
		profile.tabBarItem = UITabBarItem(title: "Profile", image: nil, tag: 3)

		return [featured, activity, search, profile]
	}

	static func presentCampaignViewController(in vc:UIViewController,
											  with campaignVM:PartialCampaignVM) {
		let new = R.storyboard.campaign.campaignVC()!
		new.vm = CampaignVM(campaignVM.id)
		vc.show(new, sender: self)
	}

	static func presentCampaignHTMLViewController(in vc:UIViewController,
												  for campaignVM:CampaignVM) {
		let new = R.storyboard.campaign.campaignHTMLVC()!
		new.vm = campaignVM
		vc.show(new, sender: self)
	}

	static func presentUpdatesViewController(in vc:UIViewController,
											 for campaignVM:CampaignVM) {
		guard let model = campaignVM.model else { return }
		let new = R.storyboard.updMilRew.updatesVC()!
		new.vm = UpdateAVM(model)
		vc.show(new, sender: self)
	}

	static func presentMilestonesViewController(in vc:UIViewController,
												for campaignVM:CampaignVM) {
		guard let model = campaignVM.model else { return }
		let new = R.storyboard.updMilRew.milestonesVC()!
		new.vm = MilestoneAVM(model)
		vc.show(new, sender: self)
	}

	static func presentCommentsViewController(in vc:UIViewController,
											  for campaignVM:CampaignVM) {
		guard let model = campaignVM.model else { return }
		let new = R.storyboard.updMilRew.commentsVC()!
		new.vm = CommentAVM(source: .campaign(model))
		vc.show(new, sender: self)
	}

	static func presentProfileEditViewController(in vc:UIViewController) {
		let new = R.storyboard.authProfile.profileEditVC()!
		vc.show(new, sender: self)
	}
}

fileprivate extension UIViewController {

	var inNavigationController:UINavigationController {
		return UINavigationController(rootViewController: self)
	}
}
