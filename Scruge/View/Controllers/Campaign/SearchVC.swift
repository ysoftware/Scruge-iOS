//
//  SearchVC.swift
//  Scruge
//
//  Created by ysoftware on 03/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import MVVM

final class SearchViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var loadingView: LoadingView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var tagCollectionView: UICollectionView!

	// MARK: - Properties

	private let searchController = UISearchController(searchResultsController: nil)
	private let campaignsVM = CampaignAVM()
	private let tags = ["tech", "marketplace", "hardware", "eco", "energy", "travel", "mobile", "apps", "sharing economy", "consumers", "social impact"]
	private var selectedTags:[String] = []

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		setupSearchBar()
		setupCollection()
		setupTable()
		setupVM()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		// The following block also "fixes" the problem without jumpiness after the view has already appeared on screen.
		DispatchQueue.main.async {
			self.tagCollectionView.collectionViewLayout.invalidateLayout()
		}
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		// The following line makes cells size properly in iOS 12.
		tagCollectionView.collectionViewLayout.invalidateLayout()
	}

	private func setupVM() {
		campaignsVM.delegate = self
	}

	private func setupCollection() {
		tagCollectionView.register(UINib(resource: R.nib.tagCell),
								   forCellWithReuseIdentifier: R.reuseIdentifier.tagCell.identifier)
		let layout = tagCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
		layout?.itemSize = UICollectionViewFlowLayout.automaticSize
		layout?.estimatedItemSize = CGSize(width: 100, height: 50)
	}

	private func setupTable() {
		loadingView.set(state: .ready) // TO-DO: remove after initially populating the table

		tableView.estimatedRowHeight = 400
		tableView.rowHeight = UITableView.automaticDimension
		tableView.register(UINib(resource: R.nib.campaignSmallCell),
						   forCellReuseIdentifier: R.reuseIdentifier.campaignCell.identifier)
	}

	private func setupSearchBar() {
		searchController.searchResultsUpdater = self
		searchController.delegate = self
		searchController.searchBar.delegate = self

		searchController.hidesNavigationBarDuringPresentation = false
		searchController.dimsBackgroundDuringPresentation = false

		navigationItem.titleView = searchController.searchBar
		definesPresentationContext = true
	}
}

extension SearchViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {

	func updateSearchResults(for searchController: UISearchController) {
		campaignsVM.query?.query = searchController.searchBar.text
	}

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		campaignsVM.reloadData()
	}
}

extension SearchViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		Presenter.presentCampaignViewController(in: self, with: campaignsVM.item(at: indexPath.row))
	}
}

extension SearchViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return campaignsVM.numberOfItems
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.campaignCell,
											 for: indexPath)!
			.setup(with: campaignsVM.item(at: indexPath.row))
	}
}

extension SearchViewController: UICollectionViewDataSource {

	func collectionView(_ collectionView: UICollectionView,
						numberOfItemsInSection section: Int) -> Int {
		return tags.count
	}

	func collectionView(_ collectionView: UICollectionView,
						cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let tag = tags[indexPath.item]
		return collectionView.dequeueReusableCell(
			withReuseIdentifier: R.reuseIdentifier.tagCell, for: indexPath)!
			.setup(with: tag)
			.setSelected(selectedTags.contains(tag))
	}
}

extension SearchViewController: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView,
						didSelectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath) as! TagCell
		let tag = tags[indexPath.item]

		if selectedTags.contains(tag) {
			cell.setSelected(false)
			selectedTags.removeAll(where: { $0 == tag })
		}
		else {
			cell.setSelected(true)
			selectedTags.append(tag)
		}

		campaignsVM.query?.tags = selectedTags
		campaignsVM.reloadData()
	}
}

extension SearchViewController: ArrayViewModelDelegate {

	func didChangeState<M, VM, Q>(_ arrayViewModel: ArrayViewModel<M, VM, Q>,
								  to state: ArrayViewModelState)
		where M : Equatable, VM : ViewModel<M>, Q : Query {
			
		switch campaignsVM.state {
		case .error(let error):
			let message = ErrorHandler.message(for: error)
			loadingView.set(state: .error(message))
		case .loading, .initial:
			loadingView.set(state: .loading)
		case .ready:
			if campaignsVM.isEmpty {
				loadingView.set(state: .error("No campaigns were found for your request"))
			}
			else {
				loadingView.set(state: .ready)
			}
		default: break
		}
	}

	func didUpdateData<M, VM, Q>(_ arrayViewModel: ArrayViewModel<M, VM, Q>, _ update: MVVM.Update)
		where M : Equatable, VM : ViewModel<M>, Q : Query {
			tableView.reloadData()
	}
}
