//
//  CategoryVM.swift
//  Scruge
//
//  Created by ysoftware on 02/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

final class CategoryVM: ViewModel<Category> {

	var name:String {
		return model?.name ?? ""
	}
}
