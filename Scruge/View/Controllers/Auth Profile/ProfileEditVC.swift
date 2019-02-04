//
//  ProfileEditVC.swift
//  Scruge
//
//  Created by ysoftware on 04/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import Result
import appendAttributedString

final class ProfileEditViewController: UIViewController {

	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var saveButton: Button!
	@IBOutlet weak var profileImage: RoundedImageView!
	@IBOutlet weak var nameField: UITextField!
	@IBOutlet weak var countryField: UITextField!
	@IBOutlet weak var descriptionField: UITextField!

	// MARK: - Actions

	@IBAction func save(_ sender: Any) {
		let name = nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
		let country = countryField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
		let description = descriptionField.text?.trimmingCharacters(in: .whitespaces)

		ProfileVM.updateProfile(name: name,
								country: country,
								description: description,
								image: selectedImage) { error in

									if let error = error {
										return self.alert(error)
									}

									if self.editingProfile == nil {
										// dismiss modal auth controller
										self.dismiss(animated: true)
										self.authCompletionBlock?(true)
									}
									else {
										// pop back to profile controller
										self.navigationController?.popViewController(animated: true)
									}
		}
	}

	@objc func cancel(_ sender: Any) {
		ask(question: R.string.localizable.label_sure_to_quit()) { reply in
			if reply {
				Service.tokenManager.removeToken()
				self.navigationController?.popViewController(animated: true)
			}
		}
	}

	@IBAction func dismissKeyboard(_ sender:Any) {
		view.endEditing(true)
	}

	@IBAction func pickImage(_ sender: Any) {
		Service.presenter.presentImagePicker(in: self, delegate: self)
	}

	// MARK: - Properties

	var authCompletionBlock:((Bool)->Void)?
	var editingProfile:ProfileVM?
	
	private var selectedImage:UIImage?
	
	// MARK: - Setup

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		localize()
		setupNavigationBar()
		setupEditing()
		setupButton()
		setupKeyboard()
	}

	private func setupKeyboard() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
											   name:UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
											   name:UIResponder.keyboardWillHideNotification, object: nil)
	}

	private func setupButton() {
		saveButton.text = editingProfile == nil
			? R.string.localizable.do_create_profile()
			: R.string.localizable.do_edit_profile()

		saveButton.addClick(self, action: #selector(save))
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		makeNavbarTransparent()
		preferSmallNavbar()
		navBarTitleColor(.white)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		makeNavbarNormal()
		navBarTitleColor()
	}

	private func setupEditing() {
		nameField.text = editingProfile?.name
		countryField.text = editingProfile?.country
		descriptionField.text = editingProfile?.description

		if let imageURL = editingProfile?.imageUrl {
			profileImage.setImage(url: imageURL, hideOnFail: false)
		}
		else {
			profileImage.image = nil
		}
	}

	private func setupNavigationBar() {
		let isEditing = editingProfile != nil
		title = isEditing ? R.string.localizable.do_update_profile() : R.string.localizable.do_create_profile()

		guard !isEditing else { return }

		navigationItem.setHidesBackButton(true, animated: false)
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: R.string.localizable.do_cancel(),
															style: .plain,
															target: self,
															action: #selector(cancel))
	}
}

extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	func imagePickerController(_ picker: UIImagePickerController,
							   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }

		guard image.size.width > 50, image.size.height > 50 else {
			return self.alert(R.string.localizable.error_image_too_small())
		}

		self.selectedImage = image.downscaled(to: 400)
		self.profileImage.image = self.selectedImage

		picker.dismiss(animated: true)
	}

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true)
	}
}

extension ProfileEditViewController {

	@objc func keyboardWillShow(notification:NSNotification) {
		guard let userInfo = notification.userInfo else { return }
		let keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
		let convertedFrame = view.convert(keyboardFrame, from: nil)
		scrollView.contentInset.bottom = convertedFrame.size.height
		scrollView.scrollIndicatorInsets.bottom = convertedFrame.size.height
	}

	@objc func keyboardWillHide(notification:NSNotification) {
		scrollView.contentInset.bottom = 0
	}
}
