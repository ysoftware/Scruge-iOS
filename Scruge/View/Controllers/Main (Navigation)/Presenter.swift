//
//  Presenter.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import SafariServices

struct Presenter {

	func setupMainTabs() -> [UIViewController] {
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

	// MARK: - Auth

	func presentAuthViewController(in vc:UIViewController,
										  completion: @escaping (Bool)->Void) {
		let new = R.storyboard.authProfile.authVC()!
		new.authCompletionBlock = completion
		vc.present(new.inNavigationController, animated: true)
	}

	func presentProfileSetupViewController(in vc:UIViewController,
												  completion: ((Bool)->Void)?) {
		let new = R.storyboard.authProfile.profileEditVC()!
		new.authCompletionBlock = completion
		vc.show(new, sender: new)
	}

	func presentProfileEditViewController(in vc:UIViewController,
												 with vm:ProfileVM) {
		let new = R.storyboard.authProfile.profileEditVC()!
		new.editingProfile = vm
		vc.show(new, sender: new)
	}

	// MARK: - Campaign

	func presentCampaignViewController(in vc:UIViewController,
											  id:String) {
		let new = R.storyboard.campaign.campaignVC()!
		new.vm = CampaignVM(id)
		vc.show(new, sender: new)
	}

	func presentContentViewController(in vc:UIViewController,
											 for campaignVM:CampaignVM) {
		let new = R.storyboard.campaign.contentVC()!
		new.campaignVM = campaignVM
		vc.show(new, sender: new)
	}

	func presentMilestonesViewController(in vc:UIViewController,
												for campaignVM:CampaignVM) {
		guard let model = campaignVM.model else { return }
		let new = R.storyboard.details.milestonesVC()!
		new.vm = MilestoneAVM(model)
		vc.show(new, sender: new)
	}

	func presentDocumentsViewController(in vc:UIViewController,
											   with vm:CampaignVM) {
		guard let vm = vm.documentsVM else { return }
		let new = R.storyboard.details.documentsVC()!
		new.vm = vm
		vc.show(new, sender: new)
	}

	func presentFaqViewController(in vc:UIViewController,
										 with vm:CampaignVM) {
		guard let vm = vm.faqVM else { return }
		let new = R.storyboard.details.faqVC()!
		new.vm = vm
		vc.show(new, sender: new)
	}

	// MARK: - Updates

	func presentContentViewController(in vc:UIViewController,
									  for update:UpdateVM) {
		let new = R.storyboard.campaign.contentVC()!
		new.updateVM = update
		vc.show(new, sender: new)
	}

	func presentUpdatesViewController(in vc:UIViewController,
									  for campaignVM:CampaignVM) {
		guard let model = campaignVM.model else { return }
		let new = R.storyboard.details.updatesVC()!
		new.vm = UpdateAVM(.campaign(model))
		vc.show(new, sender: new)
	}

	// MARK: - Comments

	func presentCommentsViewController(in vc:UIViewController,
									   for campaignVM:CampaignVM) {
		guard let model = campaignVM.model else { return }
		let new = R.storyboard.details.commentsVC()!
		new.vm = CommentAVM(source: .campaign(model))
		vc.show(new, sender: new)
	}

	func presentCommentsViewController(in vc:UIViewController,
									   for updateVM:UpdateVM) {
		guard let model = updateVM.model else { return }
		let new = R.storyboard.details.commentsVC()!
		new.vm = CommentAVM(source: .update(model))
		vc.show(new, sender: new)
	}

	// MARK: - Other

	func presentSettingsViewController(in vc:UIViewController) {
		let new = R.storyboard.main.settingsVC()!
		vc.show(new, sender: new)
	}

	// MARK: - General

	func presentActions(in vc:UIViewController,
						title:String,
						message:String,
						actions:[UIAlertAction]) {

		let alert = UIAlertController(title: title,
									  message: message,
									  preferredStyle: .actionSheet)
		for action in actions {
			alert.addAction(action)
		}
		vc.present(alert, animated: true)
	}

	func presentImagePicker(in vc:UIViewController,
							delegate: UIImagePickerControllerDelegate&UINavigationControllerDelegate) {
		let new = UIImagePickerController()
		new.delegate = delegate
		new.allowsEditing = true
		vc.present(new, animated: true)
	}

	func presentSafariViewController(in vc:UIViewController, url:URL) {
		guard UIApplication.shared.canOpenURL(url) else { return }
		let new = SFSafariViewController(url: url)
		vc.present(new, animated: true)
	}

	// MARK: - Contributions

	func presentContributeViewController(in vc:UIViewController,
										 with vm:CampaignVM) {
		let new = R.storyboard.details.contributeVC()!
		new.vm = vm
		vc.show(new, sender: new)
	}

	func presentVoteViewController(in vc:UIViewController,
								   with vm:CampaignVM) {
		let new = R.storyboard.details.voteVC()!
		new.vm = vm
		vc.show(new, sender: new)
	}

	func presentContributeViewController(in vc:UIViewController,
										 with vm:CampaignVM,
										 for reward:Reward? = nil) {

	}

	// MARK: - Wallet

	func presentWallerViewController(in vc:UIViewController) {
		let new = R.storyboard.wallet.walletVC()!
		vc.show(new, sender: new)
	}

	func presentImporKeyViewController(in vc:UIViewController) {
		let new = R.storyboard.wallet.importKeyVC()!
		vc.show(new, sender: new)
	}

	func presentPasscodeViewController(in vc:UIViewController,
											  message:String,
											  _ completion: @escaping (String?)->Void) {
		vc.askForInput("Passcode protection",
					   question: message,
					   placeholder: "Passcode...", keyboardType: .numberPad) { input in
						completion(input)
		}
	}
}

fileprivate extension UIViewController {

	var inNavigationController:UINavigationController {
		return UINavigationController(rootViewController: self)
	}
}
