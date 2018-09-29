//
//  FeaturedVC.swift
//  Scruge
//
//  Created by ysoftware on 28/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import MVVM

final class FeaturedViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var campaignTableView: UITableView!
	@IBOutlet weak var categoriesTableView: UITableView!
	var titleButton = UIButton(type: .custom)

	// MARK: - Actions

	@objc func titleTapped() {
		showCategories(!isShowingCategories)
	}

	// MARK: - Properties

	var state:FeaturedViewControllerState = .loading { didSet { updateState() }}
	var isShowingCategories = false
	let vm = CampaignAVM()
	var tableUpdateHandler:ArrayViewModelUpdateHandler!
	let categories = [ "Technology", "Donations", "Games" ]

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		setupVM()
		addTitleButton()
		setupTableView()
		setInitial()
	}

	func addTitleButton() {
		titleButton.setTitleColor(.black, for: .normal)
		titleButton.addTarget(self, action: #selector(titleTapped), for: .touchUpInside)
		navigationItem.titleView = titleButton
	}

	func setInitial() {
		selectCategory("Featured")
		categoriesTableView.isHidden = true
	}

	func setupVM() {
		tableUpdateHandler = ArrayViewModelUpdateHandler(with: campaignTableView)
		vm.delegate = self
		vm.reloadData()
	}

	func setupTableView() {
		campaignTableView.estimatedRowHeight = 400
		campaignTableView.rowHeight = UITableView.automaticDimension
		campaignTableView.register(UINib(resource: R.nib.campaignCell),
								   forCellReuseIdentifier: R.reuseIdentifier.campaignCell.identifier)

		categoriesTableView.estimatedRowHeight = 80
		categoriesTableView.rowHeight = UITableView.automaticDimension
		categoriesTableView.register(UINib(resource: R.nib.categoryCell),
									 forCellReuseIdentifier: R.reuseIdentifier.categoryCell.identifier)
	}

	// MARK: - Methods

	func showCategories(_ value:Bool) {
		guard isShowingCategories != value else { return }
		
		isShowingCategories = value
		if value {
			self.categoriesTableView.alpha = 0
			self.categoriesTableView.isHidden = false
		}
		UIView.animate(withDuration: 0.25, animations: {
			self.categoriesTableView.alpha = value ? 1 : 0
		}) { _ in
			self.categoriesTableView.isHidden = !value
		}
	}

	func updateState() {

	}

	func selectCategory(_ string:String) {
		titleButton.setTitle(string, for: .normal)
		titleButton.sizeToFit()
	}
}

extension FeaturedViewController: ArrayViewModelDelegate {

	func didUpdateData<M, VM, Q>(_ arrayViewModel: ArrayViewModel<M, VM, Q>,
								 _ update: MVVM.Update)
		where M : Equatable, VM : ViewModel<M>, Q : Query {
		
		tableUpdateHandler.handle(update)
	}

	func didChangeState(to state: ArrayViewModelState) {
		switch state {
		case .initial, .loading:
			self.state = .loading
		case .error(_):
			self.state = .error
		case .ready(_):
			self.state = .normal
		case .loadingMore, .paginationError:
			break
		}
	}
}

extension FeaturedViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		if tableView == campaignTableView {

			return
		}

		showCategories(false)
		selectCategory(categories[indexPath.row])
	}
}

extension FeaturedViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tableView == campaignTableView {
			return vm.numberOfItems
		}

		return categories.count
	}

	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		if tableView == campaignTableView {
			let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.campaignCell,
													 for: indexPath)!
			return cell.setup(vm.item(at: indexPath.row, shouldLoadMore: true))
		}

		let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.categoryCell,
												 for: indexPath)!
		return cell.setup(with: categories[indexPath.row])
		
	}
}

enum FeaturedViewControllerState {

	case loading

	case error

	case normal
}
