//
//  OtherVMs.swift
//  Scruge
//
//  Created by ysoftware on 12/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

final class DocumentVM: ViewModel<Document> {

	var name:String {
		return model?.name ?? ""
	}

	var documentUrl:URL? {
		guard let url = model?.url else { return nil }
		return URL(string: url)
	}
}
