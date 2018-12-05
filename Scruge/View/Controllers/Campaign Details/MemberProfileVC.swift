//
//  MemberProfileVC.swift
//  Scruge
//
//  Created by ysoftware on 05/12/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class MemberProfileViewController: UIViewController {

	@IBOutlet weak var socialCollectionView: UICollectionView!
	@IBOutlet weak var profileImage:UIImageView!
	@IBOutlet weak var nameLabel:UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var positionLabel: UILabel!

	var member:Member!

	// MARK: - Setup

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		setupTableView()
		refreshProfile()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		makeNavbarTransparent()
		preferLargeNavbar()
		navBarTitleColor(.white)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		makeNavbarNormal()
		navBarTitleColor()
	}

	private func setupTableView() {
		socialCollectionView.register(UINib(resource: R.nib.socialCell),
								forCellWithReuseIdentifier: R.nib.socialCell.identifier)
	}

	private func refreshProfile() {
		descriptionLabel.text = member.description
		positionLabel.text = member.position
		nameLabel.text = member.name
		profileImage.setImage(string: member.imageUrl)
	}
}

extension MemberProfileViewController: UICollectionViewDataSource {

	func collectionView(_ collectionView: UICollectionView,
						numberOfItemsInSection section: Int) -> Int {
		return member.social.count
	}

	func collectionView(_ collectionView: UICollectionView,
						cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		return collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.socialCell,
												  for: indexPath)!
			.setup(with: member.social[indexPath.item])
	}
}

extension MemberProfileViewController: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let url = URL(string: member.social[indexPath.item].url) else { return }
		Service.presenter.presentSafariViewController(in: self, url: url)
	}
}
