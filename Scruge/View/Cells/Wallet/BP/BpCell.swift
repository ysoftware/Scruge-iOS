//
//  BpCell.swift
//  Scruge
//
//  Created by ysoftware on 07/02/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import UIKit

final class BpCell: UITableViewCell {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var votesLabel: UILabel!

	@IBOutlet weak var checkboxView: RoundedView!
	@IBOutlet weak var checkboxImage: UIImageView!

	func setup(with bp:ProducerVM) -> Self {
		nameLabel.text = bp.name
		votesLabel.text = bp.votes
		return self
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		checkboxView.backgroundColor = selected ? Service.constants.color.purple : .white
		checkboxImage.isHidden = !selected
	}
}
