//
//  ViewState.swift
//  Scruge
//
//  Created by ysoftware on 02/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

/// State object to be used in a (singular) ViewModel.
enum ViewState:Equatable {

	case loading, ready, error(String)

	static func ==(lhs:ViewState, rhs:ViewState) -> Bool {
		switch (lhs, rhs) {
		case (.error, .error), (.loading, .loading), (.ready, .ready): return true
		default: return false
		}
	}
}
