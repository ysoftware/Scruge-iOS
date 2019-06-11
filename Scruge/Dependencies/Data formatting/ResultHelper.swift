//
//  ResultHelper.swift
//  Scruge
//
//  Created by ysoftware on 11/06/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import Foundation

extension Result {

	var error:Error? {
		do {
			_ = try get()
			return nil
		}
		catch let e {
			return e
		}
	}
}
