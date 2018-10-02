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
	@IBOutlet weak var loadingView: UIView!
	@IBOutlet weak var errorView: ErrorView!

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

	func didChangeState(to state: ArrayViewModelState) {
		switch state {
		case .error(let error):
			errorView.set(message: ErrorHandler.message(for: error))
		case .loadingMore:
			UIApplication.shared.isNetworkActivityIndicatorVisible = true
		case .paginationError:
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
		default: break
		}
		showView()
	}

	func showView() {
		errorView.isHidden = true
		loadingView.isHidden = true
		switch campaignVM.state {
		case .error:
			errorView.isHidden = false
		case .loading, .initial:
			loadingView.isHidden = false
		case .ready:
			if campaignVM.numberOfItems == 0 {
				errorView.set(message: "No campaigns were found for your request")
				errorView.isHidden = false
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
