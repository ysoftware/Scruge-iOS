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

	func setupMainTabs(in vc:TabbarViewController) {
		let featured = R.storyboard.campaign.featuredVC()!.inNavigationController
		featured.tabBarItem = UITabBarItem(title: R.string.localizable.title_featured(), image: #imageLiteral(resourceName: "featured"), tag: 0)

		let activity = R.storyboard.details.activityVC()!.inNavigationController
		activity.tabBarItem = UITabBarItem(title: R.string.localizable.title_activity(), image: #imageLiteral(resourceName: "bell"), tag: 1)

		let earn = R.storyboard.bounty.earnVC()!.inNavigationController
		earn.tabBarItem = UITabBarItem(title: R.string.localizable.title_earn(), image: #imageLiteral(resourceName: "pie-chart"), tag: 3)

		let wallet = R.storyboard.wallet.walletVC()!.inNavigationController
		wallet.tabBarItem = UITabBarItem(title: R.string.localizable.title_wallet(), image: #imageLiteral(resourceName: "wallet"), tag: 3)

		let profile = R.storyboard.authProfile.profileVC()!.inNavigationController
		profile.tabBarItem = UITabBarItem(title: R.string.localizable.title_profile(), image: #imageLiteral(resourceName: "tabprofile"), tag: 4)

		vc.viewControllers = [featured, activity, earn, wallet, profile]
	}

	// MARK: - Bounties

	func presentProjectViewController(in vc:UIViewController,
									  projectVM:ProjectVM) {
		let new = R.storyboard.bounty.projectVC()!
		new.vm = projectVM
		vc.show(new, sender: self)
	}

	func presentBountiesViewController(in vc:UIViewController,
									   projectVM:ProjectVM) {
		let new = R.storyboard.bounty.bountiesVC()!
		new.projectVM = projectVM
		vc.show(new, sender: self)
	}

	func presentBountyViewController(in vc:UIViewController,
									 bountyVM:BountyVM,
									 projectVM:ProjectVM) {
		let new = R.storyboard.bounty.bountyVC()!
		new.vm = bountyVM
		new.projectVM = projectVM
		vc.show(new, sender: self)
	}

	func presentSubmitViewController(in vc:UIViewController,
									 bountyVM:BountyVM,
									 projectVM:ProjectVM) {
		let new = R.storyboard.bounty.submitVC()!
		new.bountyVM = bountyVM
		new.projectVM = projectVM
		vc.show(new, sender: self)
	}

	// MARK: - Auth

	func presentLoginViewController(in vc:UIViewController,
									completion: @escaping (Bool)->Void) {
		let new = R.storyboard.authProfile.loginVC()!
		new.authCompletionBlock = completion
		vc.present(new.inNavigationController, animated: true)
	}

	func replaceWithLoginViewController(viewController vc:UIViewController,
										completion: @escaping (Bool)->Void) {
		let new = R.storyboard.authProfile.loginVC()!
		new.authCompletionBlock = completion
		vc.navigationController?.setViewControllers([new], animated: true)
	}

	func replaceWithRegisterViewController(viewController vc:UIViewController,
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

	func presentMemberProfileViewController(in vc:UIViewController,
											with member:Member) {
		let new = R.storyboard.authProfile.memberProfileVC()!
		new.member = member
		vc.show(new, sender: self)
	}

	// MARK: - Campaign

	func presentCampaignViewController(in vc:UIViewController, id:Int) {
		let new = R.storyboard.campaign.campaignVC()!
		new.vm = CampaignVM(id)
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

	func presentDetailViewController(in vc:UIViewController, faq:FaqVM) {
		let new = R.storyboard.details.detailVC()!
		new.faq = faq
		vc.show(new, sender: self)
	}

	func presentDetailViewController(in vc:UIViewController, milestone:MilestoneVM) {
		let new = R.storyboard.details.detailVC()!
		new.milestone = milestone
		vc.show(new, sender: self)
	}

	// MARK: - Updates

	func presentContentViewController(in vc:UIViewController,
									  for campaignVM:CampaignVM) {
		let new = R.storyboard.campaign.contentVC()!
		new.campaignVM = campaignVM
		vc.show(new, sender: self)
	}

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

	func presentCommentsViewController(in vc:UIViewController,
									   source avm: CommentAVM,
									   repliesTo commentVM:CommentVM,
									   presentKeyboard:Bool = false) {
		guard let model = commentVM.model,
			let source = avm.query?.source
			else { return }
		let new = R.storyboard.details.commentsVC()!
		new.vm = CommentAVM(source: .comment(source, model))
		new.shouldOpenTyping = presentKeyboard
		vc.show(new, sender: self)
	}

	// MARK: - Other

	func presentSettingsViewController(in vc:UIViewController,
									   with vm:ProfileVM) {
		let new = R.storyboard.main.settingsVC()!
		new.profileVM = vm
		vc.show(new, sender: self)
	}

	func presentPrivacyPolicy(in vc:UIViewController) {
		let url = URL(string: "https://scruge.world/privacy")!
		presentSafariViewController(in: vc, url: url)
	}

	// MARK: - General

	func presentPickerController(in vc:UIViewController,
										 with items:[String],
										 andTitle title:String? = nil,
										 _ block: @escaping (Int?)->Void) {
		let new = R.storyboard.main.pickerVC()!
		setupPopover(new)
		new.titleText = title
		new.items = items
		new.block = block
		vc.present(new, animated: true)
	}

	private func setupPopover(_ new:UIViewController) {
		new.providesPresentationContextTransitionStyle = true
		new.definesPresentationContext = true
		new.modalPresentationStyle = .overCurrentContext
		new.modalTransitionStyle = .crossDissolve
	}

	func presentAlert(in vc:UIViewController, _ message:String, _ completion: (()->Void)? = nil) {
		let new = R.storyboard.main.alertVC()!
		setupPopover(new)
		new.makeAlert(message: message) { completion?() }
		vc.present(new, animated: true)
	}

	func presentAction(in vc:UIViewController,
					   title:String,
					   action:String,
					   message:String,
					   block: @escaping ()->Void) {
		let new = R.storyboard.main.alertVC()!
		setupPopover(new)
		new.makeAlert(title: title, message: message, buttonTitle: action,
					  showCloseButton: true, block: block)
		vc.present(new, animated: true)
	}

	func presentDialog(in vc:UIViewController,
					   title:String,
					   question:String,
					   completion: @escaping (Bool)->Void) {
		let new = R.storyboard.main.alertVC()!
		setupPopover(new)
		new.makeDialog(title: title, message: question, block: completion)
		vc.present(new, animated: true)
	}

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

	/// push campaignid and then push vote vc
	func presentVoteViewController(in vc:UIViewController,
								   with campaignId:Int) {
		let vm = CampaignVM(campaignId)
		presentVoteViewController(in: vc, with: vm)

		vc.navigationController.flatMap { nav in
			let new = R.storyboard.campaign.campaignVC()!
			new.vm = vm
			nav.viewControllers.insert(new, at: nav.viewControllers.count - 1)
		}
	}

	func presentVoteResultsViewController(in vc:UIViewController,
										  with vm:CampaignVM) {
		let new = R.storyboard.details.voteResultsVC()!
		new.vm = vm
		vc.show(new, sender: self)
	}

	// MARK: - Wallet

	func presentStakingViewController(in vc:UIViewController,
									  with vm:AccountVM) {
		let new = R.storyboard.wallet.stakingVC()!
		new.accountVM = vm
		vc.show(new, sender: self)
	}

	func presentImporKeyViewController(in vc:UIViewController) {
		let new = R.storyboard.wallet.importKeyVC()!
		vc.show(new, sender: self)
	}

	func presentCreateAccountViewController(in vc:UIViewController) {
		guard !Service.settings.didCreateEosAccount else {
			let msg = R.string.localizable.alert_previously_created_eos()
			return vc.alert(msg)
		}
		let new = R.storyboard.wallet.createAccountVC()!
		vc.show(new, sender: self)
	}

	func replaceWithImporKeyViewController(viewController vc:UIViewController) {
		let new = R.storyboard.wallet.importKeyVC()!
		var vcs = Array(vc.navigationController?.viewControllers.dropLast() ?? [])
		vcs.append(new)
		vc.navigationController?.setViewControllers(vcs, animated: true)
	}

	func replaceWithCreateAccountViewController(viewController vc:UIViewController) {
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

	func replaceWithWalletViewController(viewController vc:UIViewController) {
		let new = R.storyboard.wallet.walletVC()!
		vc.navigationController?.setViewControllers([new], animated: false)
	}

	func replaceWithWalletStartViewController(viewController vc:UIViewController) {
		let new = R.storyboard.wallet.walletStartVC()!
		vc.navigationController?.setViewControllers([new], animated: false)
	}

	func replaceWithWalletNoAccountController(viewController vc:UIViewController) {
		let new = R.storyboard.wallet.walletNoAccountVC()!
		vc.navigationController?.setViewControllers([new], animated: false)
	}

	func presentTransferFragment(in vc:UIViewController, vm:AccountVM) {
		let new = R.storyboard.wallet.transferVC()!
		new.accountVM = vm
		vc.show(new, sender: self)
	}

	func presentVoteBPViewController(in vc:UIViewController, vm:AccountVM) {
		let new = R.storyboard.wallet.voteBPVC()!
		new.accountVM = vm
		vc.show(new, sender: self)
	}
}

fileprivate extension UIViewController {

	var inNavigationController:UINavigationController {
		return UINavigationController(rootViewController: self)
	}
}
