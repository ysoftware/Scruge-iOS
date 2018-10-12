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
		featured.tabBarItem = UITabBarItem(title: "Campaigns", image: nil, tag: 0)
 
		let activity = R.storyboard.details.activityVC()!.inNavigationController
		activity.tabBarItem = UITabBarItem(title: "Updates", image: nil, tag: 1)

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
		vc.show(new, sender: new)
	}

	static func presentCampaignHTMLViewController(in vc:UIViewController,
												  for campaignVM:CampaignVM) {
		let new = R.storyboard.campaign.campaignHTMLVC()!
		new.vm = campaignVM
		vc.show(new, sender: new)
	}

	static func presentUpdatesViewController(in vc:UIViewController,
											 for campaignVM:CampaignVM) {
		guard let model = campaignVM.model else { return }
		let new = R.storyboard.details.updatesVC()!
		new.vm = UpdateAVM(model)
		vc.show(new, sender: new)
	}

	static func presentMilestonesViewController(in vc:UIViewController,
												for campaignVM:CampaignVM) {
		guard let model = campaignVM.model else { return }
		let new = R.storyboard.details.milestonesVC()!
		new.vm = MilestoneAVM(model)
		vc.show(new, sender: new)
	}

	static func presentCommentsViewController(in vc:UIViewController,
											  for campaignVM:CampaignVM) {
		guard let model = campaignVM.model else { return }
		let new = R.storyboard.details.commentsVC()!
		new.vm = CommentAVM(source: .campaign(model))
		vc.show(new, sender: new)
	}

	static func presentProfileEditViewController(in vc:UIViewController, with vm:ProfileVM? = nil) {
		let new = R.storyboard.authProfile.profileEditVC()!
		new.editingProfile = vm
		vc.show(new, sender: new)
	}

	static func presentImagePicker(in vc:UIViewController,
								   delegate: UIImagePickerControllerDelegate&UINavigationControllerDelegate) {
		let new = UIImagePickerController()
		new.delegate = delegate
		new.allowsEditing = true
		vc.present(new, animated: true)
	}

	static func presentSettingsViewController(in vc:UIViewController) {
		let new = R.storyboard.main.settingsVC()!
		vc.show(new, sender: new)
	}
}

fileprivate extension UIViewController {

	var inNavigationController:UINavigationController {
		return UINavigationController(rootViewController: self)
	}
}