//
//  PagingCell.swift
//  
//
//  Created by ysoftware on 24/11/2018.
//

import UIKit

final class PagingCell: UITableViewCell, UICollectionViewDelegateFlowLayout {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var pageControl: UIPageControl!

	private var faqVM:FaqAVM!
	private var tapBlock:((Int)->Void)?

	@discardableResult
	func setup(with vm:FaqAVM,
			   _ tap: ((Int)->Void)? = nil) -> PagingCell {
		faqVM = vm
		tapBlock = tap
		titleLabel.text = "Frequently asked questions"
		collectionView.register(UINib(resource: R.nib.faqCell),
								forCellWithReuseIdentifier: R.nib.faqCell.identifier)
		pageControl.numberOfPages = vm.numberOfItems
		collectionView.reloadData()
		return self
	}

	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						sizeForItemAt indexPath: IndexPath) -> CGSize {
		return collectionView.bounds.size
	}
}

extension PagingCell: UICollectionViewDataSource {

	func collectionView(_ collectionView: UICollectionView,
						numberOfItemsInSection section: Int) -> Int {
		return faqVM.numberOfItems
	}

	func collectionView(_ collectionView: UICollectionView,
						cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		return collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.faqCell,
												  for: indexPath)!
			.setup(with: faqVM.item(at: indexPath.item))
	}

	func collectionView(_ collectionView: UICollectionView,
						willDisplay cell: UICollectionViewCell,
						forItemAt indexPath: IndexPath) {
		pageControl.currentPage = indexPath.item
	}
}

extension PagingCell: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView,
						didSelectItemAt indexPath: IndexPath) {
		tapBlock?(indexPath.item)
	}
}
