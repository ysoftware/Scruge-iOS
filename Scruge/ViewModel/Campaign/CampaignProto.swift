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

	var progress:Double { get }

	var progressString:String { get }

	var raisedString:String { get }

	var daysLeft:String { get }

	var imageUrl:URL? { get }
}

protocol PartialCampaignModelHolder {

	associatedtype Model:PartialCampaignModel

	var model:Model? { get }
}
