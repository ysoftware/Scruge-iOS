//
//  ProfileVM.swift
//  Scruge
//
//  Created by ysoftware on 04/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM
import Result

final class ProfileVM: ViewModel<Profile> {

	func load() {
		Service.api.getProfile { result in
			self.model = result.value?.profile
			self.notifyUpdated()
		}
	}

	var email:String {
		return model?.login ?? ""
	}

	var imageUrl:URL? {
		guard let model = model, let imageUrl = model.imageUrl else { return nil }
		return URL(string: imageUrl)
	}

	var description:String {
		return model?.description ?? ""
	}

	var name:String? {
		return model?.name
	}

	var country:String {
		return model?.country ?? ""
	}

	// MARK: - Update profile

	static func updateProfile(name:String?,
					   country:String?,
					   description:String?,
					   image:UIImage?,
					   _ completion: @escaping (Error?)->Void) {

		Service.api
			.updateProfile(name: name ?? "",
						   country: country ?? "",
						   description: description ?? "") { result in

							if let error = handleResponse(result) {
								return completion(error)
							}

							guard let image = image else {
								return completion(nil)
							}

							Service.api.updateProfileImage(image) { result in
								if let error = handleResponse(result) {
									return completion(error)
								}
								completion(nil)
							}
		}
	}

	private static func handleResponse(_ result: Result<ResultResponse, AnyError>) -> Error? {
		switch result {
		case .success(let response):
			return ErrorHandler.error(from: response.result) 
		case .failure(let error):
			return error
		}
	}
}
