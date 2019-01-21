//
//  EOS.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Result

class EOS {

	var systemToken:Token { return Service.eos.isMainNet ? .EOS : .SYS }

	let contractAccount = EosName.create("testaccount1")

	var isMainNet:Bool { return nodeUrl != testNodeUrl }

	let testNodeUrl = "http://35.242.241.205:7777"

	var nodeUrl:String = "" {
		didSet {
			if let _ = URL(string: nodeUrl) {
				EOSRPC.endpoint = nodeUrl
			}
		}
	}

	// MARK: - Methods

	fileprivate let chain = EOSRPC.sharedInstance

	func getAccounts(for wallet:SELocalAccount,
					 completion: @escaping (Result<[String], AnyError>)->Void) {

		guard let key = wallet.rawPublicKey else {
			return completion(.failure(AnyError(WalletError.noKey)))
		}

		chain.getKeyAccounts(pub: key) { result, error in
			guard let accountNames = result?.accountNames else {
				return completion(.failure(AnyError(error ?? EOSError.unknown)))
			}
			completion(.success(accountNames))
		}
	}

	func getResources(of account:EosName, completion: @escaping (Result<Resources, AnyError>)->Void) {
		chain.getAccount(account: account.string) { account, error in
			guard let account = account else {
				return completion(.failure(AnyError(error ?? EOSError.unknown)))
			}
			completion(.success(Resources(data: account)))
		}
	}

	func getActions(for account:EosName,
					query:ActionsQuery?,
					completion: @escaping (Result<[ActionReceipt], AnyError>)->Void) {
		chain.getActions(accountName: account.string,
						 position: query?.position ?? -1,
						 offset: query?.offset ?? -100) { result, error in
			guard let actions = result?.actions
				.sorted(by: { $0.globalActionSeq > $1.globalActionSeq })
			else {
				return completion(.failure(AnyError(error ?? EOSError.unknown)))
			}
			
			if !actions.isEmpty, query?.position == -1 {
				query?.set(limit: actions[0].accountActionSeq)
			}
			completion(.success(actions))
		}
	}

	func getBalance(for account:EosName,
					tokens:[Token],
					_ completion: @escaping ([Balance])->Void) {

		var i = 0
		var balances:[Balance] = []

		for token in tokens.distinct {
			chain.getCurrencyBalance(account: account.string,
									 symbol: token.symbol,
									 code: token.contract.string) { number, error in

										i += 1

										if let number = number {
											balances.append(Balance(token: token,
																	amount: Double(truncating: number)))
										}

										if i == tokens.count {
											completion(balances)
										}
			}
		}
	}

	func stakeResources(account:AccountModel,
						receiver:EosName? = nil,
						cpu:Balance,
						net:Balance,
						passcode:String,
						transfer:Bool = false,
						_ completion: @escaping (Result<String, AnyError>)->Void) {

		guard cpu.token == net.token else {
			return completion(.failure(AnyError(EOSError.incorrectToken)))
		}

		let data = DelegateBW(from: account.name,
							  receiver: receiver?.string ?? account.name,
							  stake_cpu_quantity: cpu.string,
							  stake_net_quantity: net.string,
							  transfer: transfer).jsonString

		let name = EosName.create("delegatebw")
		let contract = EosName.create("eosio")
		sendAction(name, contract: contract, from: account, data: data, passcode: passcode, completion)
	}

	func unstakeResources(account:AccountModel,
						receiver:EosName? = nil,
						cpu:Balance,
						net:Balance,
						passcode:String,
						transfer:Bool = false,
						_ completion: @escaping (Result<String, AnyError>)->Void) {

		guard cpu.token == net.token else {
			return completion(.failure(AnyError(EOSError.incorrectToken)))
		}

		let data = UndelegateBW(from: account.name,
							  receiver: receiver?.string ?? account.name,
							  unstake_cpu_quantity: cpu.string,
							  unstake_net_quantity: net.string).jsonString

		let name = EosName.create("undelegatebw")
		let contract = EosName.create("eosio")
		sendAction(name, contract: contract, from: account, data: data, passcode: passcode, completion)
	}

	/// send money from this account
	func sendMoney(from account:AccountModel,
				   to recipient:EosName,
				   amount:Double,
				   symbol:String,
				   memo:String = "",
				   passcode:String,
				   _ completion: @escaping (Result<String, AnyError>)->Void) {

		let quantity = "\(amount.formatRounding(to: 4, min: 4)) \(symbol)"
			.replacingOccurrences(of: ",", with: ".")
		let transfer = Transfer()
		transfer.from = account.name
		transfer.to = recipient.string
		transfer.quantity = quantity
		transfer.memo = memo

		account.wallet
			.transferToken(transfer: transfer,
						   code: "eosio.token",
						   unlockOncePasscode: passcode) { result, error in
							guard let transactionId = result?.transactionId else {
								return completion(.failure(AnyError(error ?? EOSError.unknown)))
							}
							return completion(.success(transactionId))
		}
	}

	func sendAction(_ action:EosName,
					contract:EosName? = nil,
					from account: AccountModel,
					data: String,
					passcode: String,
					_ completion: @escaping (Result<String, AnyError>)->Void) {

		guard let params = try? AbiJson(code: contract?.string ?? contractAccount.string,
										action: action.string,
										json: data) else {
											return completion(.failure(AnyError(EOSError.abiError)))
		}

		account.wallet
			.pushTransaction(abi: params,
							 account: account.name,
							 unlockOncePasscode: passcode) { result, error in
								guard let transactionId = result?.transactionId else {
									return completion(.failure(AnyError(error ?? EOSError.unknown)))
								}
								return completion(.success(transactionId))
		}
	}

}
