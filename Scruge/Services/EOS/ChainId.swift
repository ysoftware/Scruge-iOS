//
//  ChainId.swift
//  Scruge
//
//  Created by ysoftware on 06/02/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import Foundation

enum EosChainId:String {

	case main = "aca376f206b8fc25a6ed44dbdc66547c36c6c33e3a119ffbeaef943642f0e906"

	case kylin = "5fff1dae8dc8e2fc4d5b23b2c7665c97f9e9d8edf2b6485a86ba311c25639191"

	case jungle = "85c21b838825bf70b20cd327146f4092a41eb369fe57aec315e5ed0881bb9f7d"

	var name:String {
		switch self {
		case .main: return "Main Net"
		case .kylin: return "Kylin Test Net"
		case .jungle: return "Jungle Test Net"
		}
	}
}
