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
	@IBOutlet weak var loadingView: LoadingView!

	// MARK: - Actions

	@objc func titleTapped() {
		showCategories(!isShowingCategories)
	}

	// MARK: - Properties

	private var titleButton = UIButton(type: .custom)
	private var isShowingCategories = false
	private let campaignVM = CampaignAVM()
	private var tableUpdateHandler:ArrayViewModelUpdateHandler!
	private let categoriesVM = CategoryAVM()

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
		selectCategory(nil)
		categoriesTableView.isHidden = true
	}

	func setupVM() {
		tableUpdateHandler = ArrayViewModelUpdateHandler(with: campaignTableView)
		campaignVM.delegate = self
		// campaignVM.reloadData() in setInitial() -> selectCategory(nil)

		categoriesVM.delegate = self
		categoriesVM.reloadData()
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

	func selectCategory(_ vm:CategoryVM?) {
		campaignVM.query?.category = vm
		campaignVM.reloadData()

		titleButton.setTitle(vm?.name ?? "Featured", for: .normal)
		titleButton.sizeToFit()
	}
}

extension FeaturedViewController: ArrayViewModelDelegate {

	func didUpdateData<M, VM, Q>(_ arrayViewModel: ArrayViewModel<M, VM, Q>,
								 _ update: MVVM.Update)
		where M : Equatable, VM : ViewModel<M>, Q : Query {

			if arrayViewModel === campaignVM {
				tableUpdateHandler.handle(update)
			}
			else {
				categoriesTableView.reloadData()
			}
	}

	func didChangeState<M, VM, Q>(_ arrayViewModel: ArrayViewModel<M, VM, Q>,
								  to state: ArrayViewModelState)
		where M : Equatable, VM : ViewModel<M>, Q : Query {
			
		switch campaignVM.state {
		case .error(let error):
			let message = ErrorHandler.message(for: error)
			loadingView.set(state: .error(message))
		case .loading, .initial:
			loadingView.set(state: .loading)
		case .ready:
			if campaignVM.isEmpty {
				loadingView.set(state: .error("No campaigns were found for your request"))
			}
			else {
				loadingView.set(state: .ready)
			}
		default: break
		}
	}
}

extension FeaturedViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		if tableView == campaignTableView {
			return Presenter
				.presentCampaignViewController(in: self, with: campaignVM.item(at: indexPath.row))
		}

		showCategories(false)
		selectCategory(categoriesVM.item(at: indexPath.row))
	}
}

extension FeaturedViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tableView == campaignTableView {
			return campaignVM.numberOfItems
		}

		return categoriesVM.numberOfItems
	}

	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		if tableView == campaignTableView {
			let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.campaignCell,
													 for: indexPath)!
			return cell.setup(with: campaignVM.item(at: indexPath.row, shouldLoadMore: true))
		}

		let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.categoryCell,
												 for: indexPath)!
		return cell.setup(with: categoriesVM.item(at: indexPath.row))
	}
}
