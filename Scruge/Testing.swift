//
//  Testing.swift
//  Scruge
//
//  Created by ysoftware on 26/12/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

#if DEBUG
import SwiftyRSA

/// Class used to test out features before implementing them
final class Test {

	static func run() {

	}

	static func testRSA() {
		let backendKeyPair = try! SwiftyRSA.generateRSAKeyPair(sizeInBits: 2048)
		let publicKey = try! backendKeyPair.publicKey.base64String()
		let privateKey = try! backendKeyPair.privateKey.base64String()
		print("publicKey\n\(publicKey)\n")
		print("privateKey\n\(privateKey)\n")

		let range = (0..<5)
		let values = range.map { _ in Bool.random() }
		let votes = range.map { i in return userVote(values[i], publicKey, i) }

		print("original values:")
		print(values)

		let results = decrypt(votes, privateKey)
		print("results:")
		print(results)

		print("encoded values:")

		votes.forEach {
			print($0)
			print("\(($0 as NSData))\n")
		}

		print(values == results ? "success!" : "failure!")
		print("\n")

		exit(0)
	}

	static func userVote(_ value:Bool, _ publicKey:String, _ userId:Int) -> Data {
		let string = "\(value ? 1 : 0)-\(userId)"
		let clear = try! ClearMessage(string: string, using: .utf8)
		let publicKey = try! SwiftyRSAPublicKey(base64Encoded: publicKey)
		return try! clear.encrypted(with: publicKey, padding: .PKCS1).data
	}

	static func decrypt(_ values:[Data], _ privateKey:String) -> [Bool] {
		let privateKey = try! SwiftyRSAPrivateKey(base64Encoded: privateKey)

		return values.map { value in
			let result = EncryptedMessage(data: value)
			let message = try! result.decrypted(with: privateKey, padding: .PKCS1)
			let string = try! message.string(encoding: .utf8)
			return string.starts(with: "1") ? true : false
		}
	}
}
#endif
