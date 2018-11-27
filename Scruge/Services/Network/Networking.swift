//
//  Networking.swift
//  Scruge
//
//  Created by ysoftware on 09/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import SwiftHTTP
import Result

protocol Networking {

	var baseUrl:String { get }

	func get<T:Codable>(_ request:String,
						_ params:HTTPParameterProtocol?,
						_ completion: @escaping (Result<T, AnyError>)->Void)

	func post<T:Codable>(_ request:String,
						 _ params:HTTPParameterProtocol?,
						 _ completion: @escaping (Result<T, AnyError>)->Void)

	func put<T:Codable>(_ request:String,
						_ params:HTTPParameterProtocol?,
						_ completion: @escaping (Result<T, AnyError>)->Void)

	func upload(_ request:String,
				_ params:[String:Any]?,
				data:Data,
				fileName:String,
				mimeType:String,
				_ completion: @escaping (Result<ResultResponse, AnyError>)->Void)
}
