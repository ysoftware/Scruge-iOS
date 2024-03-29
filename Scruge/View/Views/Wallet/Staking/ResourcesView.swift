//
//  ResourcesView.swift
//  Scruge
//
//  Created by ysoftware on 17/01/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import UIKit
import MVVM

@IBDesignable
final class ResourcesView: UIView {

	@IBOutlet var contentView: UIView!

	// controls
	@IBOutlet weak var controlsView: UIStackView!
	@IBOutlet weak var button: Button!
	@IBOutlet weak var ramButton: Button!

	@IBOutlet weak var resourcesView: UIStackView!
	@IBOutlet weak var ramView: UIStackView!

	// cpu
	@IBOutlet weak var cpuStakedLabel: UILabel!
	@IBOutlet weak var cpuLabel: UILabel!
	@IBOutlet weak var cpuProgress: ProgressView!

	// net
	@IBOutlet weak var netStakedLabel: UILabel!
	@IBOutlet weak var netLabel: UILabel!
	@IBOutlet weak var netProgress: ProgressView!

	// ram
	@IBOutlet weak var ramLabel: UILabel!
	@IBOutlet weak var ramProgress: ProgressView!

	// MARK: - Properties

	// MARK: - Setup

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}

	private func setup() {
		Bundle.main.loadNibNamed("ResourcesView", owner: self, options: nil)
		addSubview(contentView)
		contentView.frame = self.bounds
		contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		contentView.backgroundColor = .clear
		self.backgroundColor = .clear

		localize()
		setupViews()
		setupActions()
	}

	private func setupViews() {
		vm.delegate = self

		let c = Service.constants.color
		[(cpuProgress!, c.cpu, c.cpuBackground),
		(netProgress!, c.net, c.netBackground),
		(ramProgress!, c.ram, c.ramBackground)].forEach {
			$0.0.mode = .progress(tintColor: $0.1, backColor: $0.2, showLabels: false)
		}
	}

	private func setupActions() {
		button.addClick(self, action: #selector(stakeClick))
		ramButton.addClick(self, action: #selector(ramClick))
	}

	// MARK: - Methods

	private let vm = ResourcesVM()

	var accountName:EosName? {
		didSet {
			vm.accountName = accountName
			vm.load()
		}
	}

	@IBInspectable var hideRam:Bool = false {
		didSet {
			ramView.isHidden = hideRam
			superview?.setNeedsLayout()
		}
	}

	@IBInspectable var hideResources:Bool = false {
		didSet {
			resourcesView.isHidden = hideResources
			superview?.setNeedsLayout()
		}
	}

	@IBInspectable var hideControls:Bool = false {
		didSet {
			controlsView.isHidden = hideControls
			superview?.setNeedsLayout()
		}
	}

	private func updateViews() {
		cpuProgress.value = vm.cpuUsedValue
		cpuProgress.firstGoal = vm.cpuLimitValue
		netProgress.value = vm.netUsedValue
		netProgress.firstGoal = vm.netLimitValue
		ramProgress.value = vm.ramUsedValue
		ramProgress.firstGoal = vm.ramLimitValue

		cpuStakedLabel.text = vm.cpuWeight
		netStakedLabel.text = vm.netWeight

		cpuLabel.text = vm.cpu
		netLabel.text = vm.net
		ramLabel.text = vm.ram
	}

	// MARK: - Actions

	var stakeBlock:(()->Void)? = nil

	@objc func stakeClick(_ sender:Any) {
		stakeBlock?()
	}

	var ramBlock:(()->Void)? = nil

	@objc func ramClick(_ sender:Any) {
		ramBlock?()
	}
}

extension ResourcesView: ViewModelDelegate {

	func didUpdateData<M>(_ viewModel: ViewModel<M>) where M : Equatable {
		updateViews()
	}
}
