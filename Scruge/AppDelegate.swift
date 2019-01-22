//
//  AppDelegate.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import FirebaseCore

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions
		launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		// init with node url from settings
		let url:String? = Service.settings.get(.nodeUrl)
		Service.eos.nodeUrl = url ?? Service.eos.testNodeUrl

		FirebaseApp.configure()
		Service.api.setEnvironment(.prod)

		return true
	}
}
