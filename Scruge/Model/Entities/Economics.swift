//
//  Economics.swift
//  Scruge
//
//  Created by ysoftware on 26/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

#warning("убрать optional значения где они не нужны")

struct Economics: Equatable, Codable {

	/// максимальный лимит сбора инвестиций
	let hardCap:Double

	/// минимальный лимит для успешного завершения кампании
	let softCap:Double

	/// количество собранных средств
	let raised:Double

	/// процент токенов на публичную продажу
	let publicTokenPercent:Double

	/// полный объем токенов
	let tokenSupply:Double

	/// вариация годовой инфляции (0% - 4%)
	let annualInflationPercent:Range?

	/// минимальный лимит инвестиции
	let minUserContribution:Double

	/// макс лимит инвестиции на 1 пользователя
	let maxUserContribution:Double

	/// изначальная выдача после завеершения сбора средств
	let initialFundsReleasePercent:Double
}