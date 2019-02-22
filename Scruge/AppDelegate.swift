//
//  AppDelegate.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import FirebaseCore
import UserNotifications
import FirebaseMessaging

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions
		launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		// eos

		if let url:String = Service.settings.get(.nodeUrl), let _ = URL(string: url) {
			Service.eos.nodeUrl = url
		}
		else {
			Service.eos.nodeUrl = "https://eos.greymass.com"
		}

		// api
		Service.api.setEnvironment(.prod)

		// push notifications
		UNUserNotificationCenter.current().delegate = self
		let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
		UNUserNotificationCenter.current().requestAuthorization(options: authOptions) {_, _ in }
		application.registerForRemoteNotifications()

		// firebase
		FirebaseApp.configure()

		#if DEBUG

		// launch arguments
		let args = ProcessInfo.processInfo.arguments

		if args.contains(LaunchArgs.EosTestNodeArgument) {
			Service.eos.nodeUrl = Service.eos.testNodeUrl
		}

//		Service.api.setEnvironment(.test)
//		Service.eos.nodeUrl = Service.eos.testNodeUrl
		#endif

		return true
	}
}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {

	func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
		print(remoteMessage.appData)
	}

	func application(_ application: UIApplication,
					 didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		print("didRegisterForRemoteNotificationsWithDeviceToken")
	}

	func application(_ application: UIApplication,
					 didFailToRegisterForRemoteNotificationsWithError error: Error) {
		print("didFailToRegisterForRemoteNotificationsWithError")
	}
}
