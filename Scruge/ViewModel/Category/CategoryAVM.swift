//
//  CategoryAVM.swift
//  Scruge
//
//  Created by ysoftware on 02/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM
import Result

final class CategoryAVM: SimpleArrayViewModel<Category, CategoryVM> {

	override func fetchData(_ block: @escaping (Result<[Category], AnyError>) -> Void) {
		Service.api.getCategories { result in
			switch result {
			case .success(let response):
				if let data = response.data {
					block(.success(data))
				}
				else {
					let error = ErrorHandler.error(from: response.result)
					block(.failure(AnyError(error ?? NetworkingError.unknown)))
				}
			case .failure(let error):
				block(.failure(error))
			}
		}
	}
}
