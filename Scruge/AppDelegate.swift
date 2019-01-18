//
//  AppDelegate.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions
		launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		// init with node url from settings
		let url:String? = Service.settings.get(.nodeUrl)
		Service.eos.nodeUrl = url ?? Service.eos.testNodeUrl

		#if DEBUG
		Service.api.setEnvironment(.prod)
		Test.run()
		#else
		Service.api.setEnvironment(.prod)
		#endif


		return true
	}
}
