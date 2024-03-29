//
//  Codable.swift
//  FirestoreHelper
//
//  Created by Yaroslav Erohin on01.10.2017.
//  Copyright © 2017 Ysoftware. All rights reserved.
//

import Foundation

public extension Decodable {

	init?(from data:Data) {
		do {
			self = try JSONDecoder().decode(Self.self, from: data)
		}
		catch {
			print("decodable init: \(error)")
			return nil
		}
	}

	/// Инициализовать объект Decodable с помощью Dictionary.
	init?(_ dict:[String:Any]?) {
		guard let dict = dict else { return nil }

		do {
			let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
			self = try JSONDecoder().decode(Self.self, from: data)
		}
		catch {
			print("decodable init: \(error)")
			return nil
		}
	}

}

public extension Encodable {

	var jsonString:String {
		do {
			let data = try JSONEncoder().encode(self)
			return String(data: data, encoding: .utf8) ?? "<Error: Could not convert json data to string.>"
		}
		catch {
			return "<Error: Could not encode this dictionary: (\(error)>"
		}
	}

	/// Преобразовать объект Encodable в Dictionary.
	func toDictionary() -> [String:Any] {
		do {
			let data = try JSONEncoder().encode(self)
			let value = try JSONDecoder().decode(JSONAny.self, from: data)
			if let value_ = value.value as? [String:Any] {
				return value_
			}
			else {
				print("encodable.asDict: something went wrong and needs debugging")
				return [:]
			}
		}
		catch let error {
			print("toDictionary(): \(error)")
			return [:]
		}
	}
}

/// Dictionary -> T
extension Dictionary where Key == String {

	/// Преобразовать в объект.
	/// - Parameter class: класс объекта.
	func parse<T:Decodable>(object class:T.Type = T.self) -> T? {
		do {
			var dict = self as [String:Any]
			if let dd = self as? [String: AnyCodable] {
				dict = Dictionary<String, Any>(uniqueKeysWithValues: dd.map { ($0, $1.value) })
			}
			let data = try JSONSerialization.data(withJSONObject: dict)
			return try JSONDecoder().decode(T.self, from: data)
		}
		catch {
			print("parse: parse \(T.self): \(error)")
			return nil
		}
	}
}

/// [Dictionary] -> [T:Decodable]
extension Array where Element == Dictionary<String, Any> {

	/// Преобразовать в объект.
	/// - Parameter class: класс объекта.
	func parse<T:Decodable>(arrayOf class:T.Type = T.self) -> [T] {
		do {
			let data = try JSONSerialization.data(withJSONObject: self)
			return try JSONDecoder().decode([T].self, from: data)
		}
		catch {
			print("parse: parse arrayOf \(T.self): \(error)")
			return []
		}
	}
}
