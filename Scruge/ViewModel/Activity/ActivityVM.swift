//
//  ActivityVM.swift
//  Scruge
//
//  Created by ysoftware on 16/01/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import MVVM

enum ActivityType:String {

	case reply = "Reply"

	case update = "Update"

	case voting = "Vooting"

	case fundingInfo = "Funding" // TO-DO: change
}

final class ActivityVM: ViewModel<ActivityHolder> {

	
}
