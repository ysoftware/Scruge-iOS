//
//  Alert.swift
//  Scruge
//
//  Created by ysoftware on 25/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

extension UIViewController {

	func alert(_ error:Error, _ completion: (()->Void)? = nil) {
		let message = ErrorHandler.message(for: error)
		alert(message, completion)
	}

	func alert(_ message:String, _ completion: (()->Void)? = nil) {
		let vc = (tabBarController ?? navigationController ?? self)
		Service.presenter.presentAlert(in: vc, message, completion)
	}

	func ask(title: String = "", question:String, waitFor completion: @escaping (Bool) -> Void) {
		let vc = (tabBarController ?? navigationController ?? self)
		Service.presenter.presentDialog(in: vc,
										title: title,
										question: question,
										completion: completion)
	}

	func askForInput(_ title:String = "Attention!",
					 question:String,
					 placeholder:String = "",
					 keyboardType:UIKeyboardType = .default,
					 isSecure:Bool = false,
					 waitFor completion: @escaping (String?) -> Void) {

		let vc = (tabBarController ?? navigationController ?? self)

		let alertController = UIAlertController(title: title, message: question, preferredStyle: .alert)
		alertController.addTextField { textField in
			textField.placeholder = placeholder
			textField.keyboardType = keyboardType
			textField.isSecureTextEntry = isSecure
		}
		alertController.addAction(UIAlertAction(title: "Send", style: .default) { alert in
			let textField = alertController.textFields![0] as UITextField
			completion(textField.text)
		})
		alertController.addAction(UIAlertAction(title: "Cancel", style: .default) { action in
			completion(nil)
		})
		vc.present(alertController, animated: true, completion: nil)
	}
}
