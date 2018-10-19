//
//  Alert.swift
//  Scruge
//
//  Created by ysoftware on 25/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

extension UIViewController {

	func alert(_ message:String) {
		let string = message
		let alert = UIAlertController(title: "Attention!", message: string, preferredStyle: .alert)
		let action = UIAlertAction(title: "OK", style: .default) { _ in
			alert.dismiss(animated: true)
		}
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}

	func ask(_ title: String = "Attention!", question:String,
			 waitFor completion: @escaping (Bool) -> Void) {

		let alert = UIAlertController(title: title, message: question, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
			completion(true)
			alert.dismiss(animated: true)
		})
		alert.addAction(UIAlertAction(title: "No", style: .default) { _ in
			completion(false)
			alert.dismiss(animated: true)
		})
		present(alert, animated: true, completion: nil)
	}

	func askForInput(_ title:String = "Attention!",
					 question:String,
					 placeholder:String = "",
					 keyboardType:UIKeyboardType = .default,
					 waitFor completion: @escaping (String?) -> Void) {

		let alertController = UIAlertController(title: title, message: question, preferredStyle: .alert)
		alertController.addTextField { textField in
			textField.placeholder = placeholder
			textField.keyboardType = .numberPad
		}
		alertController.addAction(UIAlertAction(title: "Send", style: .default) { alert in
			let textField = alertController.textFields![0] as UITextField
			completion(textField.text)
		})
		alertController.addAction(UIAlertAction(title: "Cancel", style: .default) { action in
			completion(nil)
		})
		present(alertController, animated: true, completion: nil)
	}
}
