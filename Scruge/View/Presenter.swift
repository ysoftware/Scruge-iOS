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
}

fileprivate extension UIViewController {

	var inNavigationController:UINavigationController {
		return UINavigationController(rootViewController: self)
	}
}
