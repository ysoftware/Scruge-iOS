//
//  ProjectVC.swift
//  Scruge
//
//  Created by ysoftware on 15/02/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import UIKit

final class ProjectViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var button: Button!
	@IBOutlet weak var buttonView: UIView!
	@IBOutlet weak var scrollView: UIScrollView!

	@IBOutlet weak var topImage: UIImageView?
	@IBOutlet weak var topWebView: UIWebView?
	@IBOutlet weak var topNameLabel: UILabel!
	@IBOutlet weak var topDescriptionLabel: UILabel!
	@IBOutlet weak var socialCollectionView: UICollectionView!

	@IBOutlet weak var tokenSupplyLabel: UILabel!
	@IBOutlet weak var tokenInflationLabel: UILabel!
	@IBOutlet weak var tokenOtherTitleLabel: UILabel!
	@IBOutlet weak var tokenOtherValueLabel: UILabel!

	@IBOutlet weak var documentsView: CardView!
	@IBOutlet weak var documentsTableView: UITableView!
	@IBOutlet weak var documentsTableViewHeightConstraint: NSLayoutConstraint!

	// MARK: - Properties

	var vm:ProjectVM!
	private var didLoadMedia = false
	private var imageUrl:URL?

	private let NAVBAR_LIMIT:CGFloat = 240

	var offset:CGFloat = 0 {
		didSet {
			setNeedsStatusBarAppearanceUpdate()
			if offset > NAVBAR_LIMIT {
				preferSmallNavbar()
				makeNavbarNormal(with: vm.name)
			}
			else {
				preferSmallNavbar()
				makeNavbarTransparent()
			}
		}
	}

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		localize()
		setupViews()
		setupVM()
		setupActions()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
//
//		if vm.state == .ready {
//			setupBottomButton()
//		}

//		vm.delegate = self
//		reloadData()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if offset < NAVBAR_LIMIT {
			preferSmallNavbar()
			makeNavbarTransparent()
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		makeNavbarNormal()
	}

	private func setupVM() {
//		vm.delegate = self
	}

	private func setupViews() {
		showContributeButton(true)

		// make table view go under the navigation bar
		if #available(iOS 11.0, *) {
			scrollView.contentInsetAdjustmentBehavior = .never
		}
		automaticallyAdjustsScrollViewInsets = false

		documentsTableView.estimatedRowHeight = 50
		documentsTableView.rowHeight = UITableView.automaticDimension

		documentsTableView.register(UINib(resource: R.nib.documentCell),
						   forCellReuseIdentifier: R.reuseIdentifier.documentCell.identifier)
		documentsTableView.reloadData()
		documentsTableViewHeightConstraint.constant = documentsTableView.contentSize.height

		socialCollectionView.register(UINib(resource: R.nib.socialCell),
								forCellWithReuseIdentifier: R.nib.socialCell.identifier)

		documentsView.isHidden = vm.documents.isEmpty
		socialCollectionView.isHidden = vm.social.isEmpty

		// views
		topNameLabel.text = vm.name
		topDescriptionLabel.text = vm.description

		tokenSupplyLabel.text = vm.tokenSupply
		tokenInflationLabel.text = vm.inflation

		if let date = vm.tokenListingDate {
			tokenOtherTitleLabel.text = R.string.localizable.label_listing_date()
			tokenOtherValueLabel.text = date
		}
		else if let name = vm.tokenExchange {
			tokenOtherTitleLabel.text = R.string.localizable.label_listed_on_exchange(name)
			tokenOtherValueLabel.isHidden = true
		}
		else {
			tokenOtherTitleLabel.text = R.string.localizable.label_not_listed()
			tokenOtherValueLabel.isHidden = true
		}

		if let str = vm.videoUrl, let url = URL(string: str) {
			setupWebView(with: url)
		}
	}

	private func setupActions() {
		button.addClick(self, action: #selector(seeBounties))
	}

	// MARK: - Actions

	@objc func seeBounties(_ sender:Any) {
		Service.presenter.presentBountiesViewController(in: self, projectVM: vm)
	}

	// MARK: - Methods

	private func showContributeButton(_ visible:Bool = true) {
		let inset = buttonView.frame.height + 20
		let value = visible ? inset : 0

		if #available(iOS 11.0, *) {
			scrollView.contentInset.bottom = value
			scrollView.scrollIndicatorInsets.bottom = value
		}

		buttonView.isHidden = !visible
		buttonView.isHidden = !visible
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return offset > NAVBAR_LIMIT ? .default : .lightContent
	}
	
	private func setupWebView(with url:URL) {
		guard !didLoadMedia, let topWebView = topWebView else {
			return
		}
		topWebView.isHidden = true
		topImage?.isHidden = true
		topWebView.delegate = self
		topWebView.isHidden = false
		topWebView.scrollView.isScrollEnabled = false
		topWebView.allowsInlineMediaPlayback = false
		topWebView.mediaPlaybackRequiresUserAction = true

		if #available(iOS 11.0, *) {
			topWebView.scrollView.contentInsetAdjustmentBehavior = .never
		}
		topWebView.loadRequest(URLRequest(url: url))
		didLoadMedia = true
	}

	private func setupImageView() {
		topWebView?.isHidden = true
		topImage?.isHidden = false
		topImage?.setImage(url: imageUrl, hideOnFail: false)
	}
}

extension ProjectViewController: UIWebViewDelegate {

	func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
		setupImageView()
	}
}

extension ProjectViewController: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		// social
	}
}

extension ProjectViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// document
	}
}

extension ProjectViewController: UICollectionViewDataSource {

	func collectionView(_ collectionView: UICollectionView,
						numberOfItemsInSection section: Int) -> Int {
		return vm.social.count
	}

	func collectionView(_ collectionView: UICollectionView,
						cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		return collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.socialCell,
												  for: indexPath)!
			.setup(with: vm.social[indexPath.item])
	}
}

extension ProjectViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView,
				   numberOfRowsInSection section: Int) -> Int {
		return vm.documents.count
	}

	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.documentCell,
											 for: indexPath)!
			.setup(with: DocumentVM(vm.documents[indexPath.row]))
	}
}

extension ProjectViewController: UIScrollViewDelegate {

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		offset = scrollView.contentOffset.y
	}
}
