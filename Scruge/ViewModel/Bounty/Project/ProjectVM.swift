//
//  ProjectVM.swift
//  Scruge
//
//  Created by ysoftware on 15/02/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import MVVM

final class ProjectVM: ViewModel<Project> {

	var providerName:String {
		return model?.providerName ?? ""
	}

	var name:String {
		return model?.projectName ?? ""
	}

	var imageUrl:String? {
		return model?.imageUrl
	}

	var description:String {
		return model?.projectDescription ?? ""
	}
}
