//
//  CurrencyConverter.swift
//  Scruge
//
//  Created by ysoftware on 25/12/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

final class ExchangeRates {

	/// exchange rates relative to usd
	private(set) var rates = [Asset:Double]()

	func convert(_ quantity:Quantity, to asset:Asset) -> Quantity? {
		if quantity.asset == asset {
			return quantity
		}
		else if asset == .usd, let rate = rates[quantity.asset] {
			return Quantity(quantity.amount * rate, asset)
		}
		else if quantity.asset == .usd, let rate = rates[asset] {
			return Quantity(quantity.amount / rate, asset)
		}
		else if let rateFrom = rates[quantity.asset], let rateTo = rates[asset] {
			return Quantity(rateFrom / rateTo * (quantity.amount), asset)
		}
		return nil
	}

	private func updateRates() {

	}
}

#if DEBUG
extension ExchangeRates {
	func setupForTesting(rates:[Asset:Double]) {
		self.rates = rates
	}
}
#endif
