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
		featured.tabBarItem = UITabBarItem(title: "Campaigns", image: #imageLiteral(resourceName: "featured"), tag: 0)

		let activity = R.storyboard.details.activityVC()!.inNavigationController
		activity.tabBarItem = UITabBarItem(title: "Activity", image: #imageLiteral(resourceName: "bell"), tag: 1)

		let wallet = R.storyboard.wallet.walletVC()!.inNavigationController
		wallet.tabBarItem = UITabBarItem(title: "Wallet", image: #imageLiteral(resourceName: "wallet"), tag: 2)

		let profile = R.storyboard.authProfile.profileVC()!.inNavigationController
		profile.tabBarItem = UITabBarItem(title: "Profile", image: #imageLiteral(resourceName: "tabprofile"), tag: 3)

		return [featured, activity, wallet, profile]
	}

	// MARK: - Auth

	func presentLoginViewController(in vc:UIViewController,
									completion: @escaping (Bool)->Void) {
		let new = R.storyboard.authProfile.loginVC()!
		new.authCompletionBlock = completion
		vc.present(new.inNavigationController, animated: true)
	}

	func replaceWithLoginViewController(in vc:UIViewController,
										completion: @escaping (Bool)->Void) {
		let new = R.storyboard.authProfile.loginVC()!
		new.authCompletionBlock = completion
		vc.navigationController?.setViewControllers([new], animated: true)
	}

	func replaceWithRegisterViewController(in vc:UIViewController,
										   completion: @escaping (Bool)->Void) {
		let new = R.storyboard.authProfile.registerVC()!
		new.authCompletionBlock = completion
		vc.navigationController?.setViewControllers([new], animated: true)
	}

	func presentProfileSetupViewController(in vc:UIViewController,
												  completion: ((Bool)->Void)?) {
		let new = R.storyboard.authProfile.profileEditVC()!
		new.authCompletionBlock = completion
		vc.show(new, sender: self)
	}

	func presentProfileEditViewController(in vc:UIViewController,
												 with vm:ProfileVM) {
		let new = R.storyboard.authProfile.profileEditVC()!
		new.editingProfile = vm
		vc.show(new, sender: self)
	}

	// MARK: - Campaign

	func presentCampaignViewController(in vc:UIViewController,
									   id:Int) {
		let new = R.storyboard.campaign.campaignVC()!
		new.vm = CampaignVM(id)
		vc.show(new, sender: self)
	}

	func presentContentViewController(in vc:UIViewController,
											 for campaignVM:CampaignVM) {
		let new = R.storyboard.campaign.contentVC()!
		new.campaignVM = campaignVM
		vc.show(new, sender: self)
	}

	func presentMilestonesViewController(in vc:UIViewController,
												for campaignVM:CampaignVM) {
		guard let model = campaignVM.model else { return }
		let new = R.storyboard.details.milestonesVC()!
		new.vm = MilestoneAVM(model)
		vc.show(new, sender: self)
	}

	func presentDocumentsViewController(in vc:UIViewController,
											   with vm:CampaignVM) {
		guard let vm = vm.documentsVM else { return }
		let new = R.storyboard.details.documentsVC()!
		new.vm = vm
		vc.show(new, sender: self)
	}

	func presentFaqViewController(in vc:UIViewController,
										 with vm:CampaignVM) {
		guard let vm = vm.faqVM else { return }
		let new = R.storyboard.details.faqVC()!
		new.vm = vm
		vc.show(new, sender: self)
	}

	// MARK: - Updates

	func presentContentViewController(in vc:UIViewController,
									  for update:UpdateVM) {
		let new = R.storyboard.campaign.contentVC()!
		new.updateVM = update
		vc.show(new, sender: self)
	}

	func presentUpdatesViewController(in vc:UIViewController,
									  for campaignVM:CampaignVM) {
		guard let model = campaignVM.model else { return }
		let new = R.storyboard.details.updatesVC()!
		new.vm = UpdateAVM(.campaign(model))
		vc.show(new, sender: self)
	}

	// MARK: - Comments

	func presentCommentsViewController(in vc:UIViewController,
									   for campaignVM:CampaignVM) {
		guard let model = campaignVM.model else { return }
		let new = R.storyboard.details.commentsVC()!
		new.vm = CommentAVM(source: .campaign(model))
		vc.show(new, sender: self)
	}

	func presentCommentsViewController(in vc:UIViewController,
									   for updateVM:UpdateVM) {
		guard let model = updateVM.model else { return }
		let new = R.storyboard.details.commentsVC()!
		new.vm = CommentAVM(source: .update(model))
		vc.show(new, sender: self)
	}

	// MARK: - Other

	func presentSettingsViewController(in vc:UIViewController,
									   with vm:ProfileVM) {
		let new = R.storyboard.main.settingsVC()!
		new.profileVM = vm
		vc.show(new, sender: self)
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
		vc.show(new, sender: self)
	}

	func presentVoteViewController(in vc:UIViewController,
								   with vm:CampaignVM) {
		let new = R.storyboard.details.voteVC()!
		new.vm = vm
		vc.show(new, sender: self)
	}

	func presentVoteResultsViewController(in vc:UIViewController,
										  with vm:CampaignVM) {
		let new = R.storyboard.details.voteResultsVC()!
		new.vm = vm
		vc.show(new, sender: self)
	}

	// MARK: - Wallet

	func presentWallerViewController(in vc:UIViewController) {
		let new = R.storyboard.wallet.walletVC()!
		vc.show(new, sender: self)
	}

	func presentImporKeyViewController(in vc:UIViewController) {
		let new = R.storyboard.wallet.importKeyVC()!
		vc.show(new, sender: self)
	}

	func presentCreateAccountViewController(in vc:UIViewController) {
		let new = R.storyboard.wallet.createAccountVC()!
		vc.show(new, sender: self)
	}

	func replaceWithImporKeyViewController(with vc:UIViewController) {
		let new = R.storyboard.wallet.importKeyVC()!
		var vcs = Array(vc.navigationController?.viewControllers.dropLast() ?? [])
		vcs.append(new)
		vc.navigationController?.setViewControllers(vcs, animated: true)
	}

	func replaceWithCreateAccountViewController(with vc:UIViewController) {
		let new = R.storyboard.wallet.createAccountVC()!
		var vcs = Array(vc.navigationController?.viewControllers.dropLast() ?? [])
		vcs.append(new)
		vc.navigationController?.setViewControllers(vcs, animated: true)
	}

	func presentWalletPicker(in vc:UIViewController,
							 title:String,
							 _ completion: @escaping (AccountVM?)->Void) {
		let new = R.storyboard.wallet.walletPickerVC()!
		new.block = completion
		new.string = title
		vc.present(new.inNavigationController, animated: true)
	}

	func replaceWithWalletViewController(with vc:UIViewController) {
		let new = R.storyboard.wallet.walletVC()!
		vc.navigationController?.setViewControllers([new], animated: false)
	}

	func replaceWithWalletStartViewController(with vc:UIViewController) {
		let new = R.storyboard.wallet.walletStartVC()!
		vc.navigationController?.setViewControllers([new], animated: false)
	}

	func replaceWithWalletNoAccountController(with vc:UIViewController) {
		let new = R.storyboard.wallet.walletNoAccountVC()!
		vc.navigationController?.setViewControllers([new], animated: false)
	}
}

fileprivate extension UIViewController {

	var inNavigationController:UINavigationController {
		return UINavigationController(rootViewController: self)
	}
}
