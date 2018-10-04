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

	// MARK: - Properties

	private let searchController = UISearchController(searchResultsController: nil)
	private let vm = CampaignAVM()

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		setupSearchBar()
	}

	private func setupSearchBar() {
		searchController.searchResultsUpdater = self
		searchController.delegate = self
		searchController.searchBar.delegate = self

		searchController.hidesNavigationBarDuringPresentation = false
		searchController.dimsBackgroundDuringPresentation = true

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
