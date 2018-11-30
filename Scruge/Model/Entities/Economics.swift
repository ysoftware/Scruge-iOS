//
//  Economics.swift
//  Scruge
//
//  Created by ysoftware on 26/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct Economics: Equatable, Codable {

	/// максимальный лимит сбора инвестиций
	let hardCap:Int

	/// минимальный лимит для успешного завершения кампании
	let softCap:Int

	/// количество собранных средств
	let raised:Double

	/// процент токенов на публичную продажу
	let publicTokenPercent:Double

	/// полный объем токенов
	let tokenSupply:Int

	/// вариация годовой инфляции (0% - 4%)
	let annualInflationPercent:Range

	/// минимальный лимит инвестиции
	let minUserContribution:Double

	/// макс лимит инвестиции на 1 пользователя
	let maxUserContribution:Double

	/// изначальная выдача после завеершения сбора средств
	let initialFundsReleasePercent:Double
}
