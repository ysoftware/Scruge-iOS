//
//  SearchVC.swift
//  Scruge
//
//  Created by ysoftware on 03/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var tagCollectionView: UICollectionView!

	// MARK: - Properties

	private let searchController = UISearchController(searchResultsController: nil)
	private let vm = CampaignAVM()
	private let tags = ["crypto", "services", "marketplace", "ico", "technology"]
	private var selectedTags = [""]

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		setupSearchBar()
		setupCollection()
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

	private func setupCollection() {
		tagCollectionView.register(UINib(resource: R.nib.tagCell),
								   forCellWithReuseIdentifier: R.reuseIdentifier.tagCell.identifier)
		let layout = tagCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
		layout?.itemSize = UICollectionViewFlowLayout.automaticSize
		layout?.estimatedItemSize = CGSize(width: 100, height: 50)
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
		vm.query?.query = searchController.searchBar.text
	}

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		vm.reloadData()
	}
}

extension SearchViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return vm.numberOfItems
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
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

		vm.query?.tags = selectedTags
		vm.reloadData()
	}
}
