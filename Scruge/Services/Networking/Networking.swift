//
//  Networking.swift
//  Scruge
//
//  Created by ysoftware on 25/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import SwiftHTTP
import Result

protocol Networking {
	func get(_ request:String,
			 _ params:HTTPParameterProtocol?,
			 _ completion:(Result<[String:Any], AnyError>)->Void)
}

struct Network:Networking {

	var baseUrl:String

	init(baseUrl:String) {
		self.baseUrl = baseUrl
	}

	func get(_ request:String,
			 _ params:HTTPParameterProtocol?,
			 _ completion:(Result<[String:Any], AnyError>)->Void) {

		HTTP.GET(baseUrl + request,
				 parameters: params,
				 requestSerializer: JSONParameterSerializer()) { response in

		}
	}
}
