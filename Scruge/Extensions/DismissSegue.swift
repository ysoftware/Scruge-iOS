//
//  DismissSegue.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final public class DismissSegue: UIStoryboardSegue {

	public override func perform() {
		source.dismiss(animated: true)
	}
}
