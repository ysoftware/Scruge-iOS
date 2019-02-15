//
//  CampaignProto.swift
//  Scruge
//
//  Created by ysoftware on 02/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

protocol PartialCampaignViewModel {

	var description:String { get }

	var title:String { get }

	var raised:Double { get }

	var hardCap:Int { get }

	var softCap:Int { get }

	var daysLeft:String { get }

	var imageUrl:URL? { get }
}

protocol PartialCampaignModelHolder {

	associatedtype Model:PartialCampaignModel

	var model:Model? { get }
}
