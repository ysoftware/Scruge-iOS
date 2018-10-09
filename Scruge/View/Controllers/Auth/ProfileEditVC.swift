//
//  ProfileEditVC.swift
//  Scruge
//
//  Created by ysoftware on 04/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import Result

final class ProfileEditViewController: UIViewController {

	@IBOutlet weak var profileImage: RoundedImageView!
	@IBOutlet weak var nameField: UITextField!
	@IBOutlet weak var countryField: UITextField!
	@IBOutlet weak var descriptionField: UITextField!

	// MARK: - Actions

	@IBAction func save(_ sender: Any) {
		updateProfile { success in
			if success {
				self.uploadImage { success in
					if success {
						if self.editingProfile == nil {
							// dismiss modal auth controller
							self.dismiss(animated: true)
						}
						else {
							// pop back to profile controller
							self.navigationController?.popViewController(animated: true)
						}
					}
				}
			}
		}
	}

	@objc func cancel(_ sender: Any) {
		ask(question: "Are you sure that you want to quit?") { reply in
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
		Presenter.presentImagePicker(in: self, delegate: self)
	}

	// MARK: - Properties

	var editingProfile:ProfileVM?
	private var selectedImage:UIImage?
	
	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		setupNavigationBar()
		setupEditing()
	}

	private func setupEditing() {
		nameField.text = editingProfile?.name
		countryField.text = editingProfile?.country
		descriptionField.text = editingProfile?.description

		guard let imageURL = editingProfile?.imageUrl else { return }
		profileImage.kf.setImage(with: imageURL)
	}

	private func setupNavigationBar() {
		let isEditing = editingProfile != nil
		title = isEditing ? "Update Profile" : "Create Profile"

		guard !isEditing else { return }
		
		navigationItem.setHidesBackButton(true, animated: false)
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
															style: .plain,
															target: self,
															action: #selector(cancel))
	}

	// MARK: - Methods

	private func uploadImage(_ completion: @escaping (Bool)->Void) {
		if let image = selectedImage {
			Service.api.updateProfileImage(image) { result in
				completion(self.handleResponse(result))
			}
			return completion(false)
		}
		completion(true)
	}

	private func handleResponse(_ result: Result<ResultResponse, AnyError>) -> Bool {
		switch result {
		case .success(let response):
			if let error = ErrorHandler.error(from: response.result) {
				self.alert(ErrorHandler.message(for: error))
				return false
			}
			return true
		case .failure(let error):
			self.alert(ErrorHandler.message(for: error))
			return false
		}
	}

	private func updateProfile(_ completion: @escaping (Bool)->Void) {

		guard
			let name = nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
			let country = countryField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
			let description = descriptionField.text?.trimmingCharacters(in: .whitespaces)
			else { return completion(false) }

		Service.api.updateProfile(name: name, country: country, description: description) { result in
			completion(self.handleResponse(result))
		}
	}
}

extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	func imagePickerController(_ picker: UIImagePickerController,
							   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }

		guard image.size.width > 50, image.size.height > 50 else {
			return self.alert("Selected image is too small")
		}

		self.selectedImage = image.downscaled(to: 400)
		self.profileImage.image = self.selectedImage

		picker.dismiss(animated: true)
	}

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true)
	}
}
