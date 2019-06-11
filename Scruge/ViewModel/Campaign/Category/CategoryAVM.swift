//
//  CategoryAVM.swift
//  Scruge
//
//  Created by ysoftware on 02/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM


final class CategoryAVM: SimpleArrayViewModel<Category, CategoryVM> {

	override func fetchData(_ block: @escaping (Result<[Category], Error>) -> Void) {
		Service.api.getCategories { block($0.map { $0.data }) }
	}
}
