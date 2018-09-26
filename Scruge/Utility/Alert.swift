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
		let alert = UIAlertController(title: "Внимание!", message: string, preferredStyle: .alert)
		let action = UIAlertAction(title: "ОК", style: .default) { _ in
			alert.dismiss(animated: true)
		}
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}

	func ask(_ title: String = "Внимание!", question:String,
			 waitFor completion: @escaping (Bool) -> Void) {

		let alert = UIAlertController(title: title, message: question, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Да", style: .default) { _ in
			completion(true)
			alert.dismiss(animated: true)
		})
		alert.addAction(UIAlertAction(title: "Нет", style: .default) { _ in
			completion(false)
			alert.dismiss(animated: true)
		})
		present(alert, animated: true, completion: nil)
	}

	func askForInput(_ title:String = "Внимание!",
					 question:String,
					 placeholder:String = "",
					 waitFor completion: @escaping (String?) -> Void) {

		let alertController = UIAlertController(title: title, message: question, preferredStyle: .alert)
		alertController.addTextField { textField in
			textField.placeholder = placeholder
		}
		alertController.addAction(UIAlertAction(title: "Отправить", style: .default) { alert in
			let textField = alertController.textFields![0] as UITextField
			completion(textField.text)
		})
		alertController.addAction(UIAlertAction(title: "Отмена", style: .default) { action in
			completion(nil)
		})
		present(alertController, animated: true, completion: nil)
	}
}
