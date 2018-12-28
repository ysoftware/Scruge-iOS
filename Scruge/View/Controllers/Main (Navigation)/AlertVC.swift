//
//  AlertVC.swift
//  Scruge
//
//  Created by ysoftware on 25/12/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class AlertViewController: UIViewController {

	// MARK: - Properties

	@IBOutlet var viewTap: UITapGestureRecognizer!
	@IBOutlet weak var topStack: UIStackView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var closeButton: UIButton!
	@IBOutlet weak var textLabel: UILabel!
	@IBOutlet weak var yesButton: Button!
	@IBOutlet weak var noButton: Button!
	@IBOutlet weak var cardView: CardView!

	// MARK: - Setup

	private var setupBlock:(()->Void)?

	override func viewDidLoad() {
		super.viewDidLoad()

		setupBlock?()
		setupBlock = nil

		yesButton.color = Service.constants.color.green
		topStack.isHidden = closeButton.isHidden && titleLabel.isHidden
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		cardView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
		UIView.animate(withDuration: 0.25,
					   delay: 0,
					   usingSpringWithDamping: 0.65,
					   initialSpringVelocity: 0.25,
					   options: .beginFromCurrentState,
					   animations: {
						self.cardView.transform = CGAffineTransform.identity
		})
	}

	@discardableResult
	func makeAlert(title:String = "",
				   message:String,
				   buttonTitle:String = "OK",
				   showCloseButton:Bool = false,
				   block: @escaping ()->Void) -> Self {
		setupBlock = {
			self.textLabel.text = message
			self.yesButton.isHidden = true
			self.noButton.text = buttonTitle

			if title.isEmpty {
				self.titleLabel.isHidden = true
			}
			else {
				self.titleLabel.text = title.uppercased()
			}

			self.noButton.addTargetClosure { [unowned self] _ in
				block()
				self.dismiss(animated: true)
			}
			
			let closure:(Any)->Void = { [unowned self] _ in
				self.dismiss(animated: true)
			}
			self.viewTap.addTargetClosure(closure: closure)

			if showCloseButton {
				self.closeButton.addTargetClosure(closure: closure)
			}
			else {
				self.closeButton.isHidden = true
			}
		}
		return self
	}

	@discardableResult
	func makeDialog(title:String = "", message:String, block: @escaping (Bool)->Void) -> Self {
		setupBlock = {
			self.textLabel.text = message
			self.closeButton.isHidden = true
			self.noButton.text = "NO"
			self.yesButton.text = "YES"

			if title.isEmpty {
				self.titleLabel.isHidden = true
			}
			else {
				self.titleLabel.text = title.uppercased()
			}

			let closure:(Button)->Void = { [unowned self] button in
				self.dismiss(animated: true) { block(self.yesButton == button) }
			}
			self.yesButton.addTargetClosure(closure: closure)
			self.noButton.addTargetClosure(closure: closure)
		}
		return self
	}
}
