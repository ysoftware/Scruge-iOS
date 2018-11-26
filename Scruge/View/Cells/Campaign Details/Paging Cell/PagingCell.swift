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

	private var milestoneVM:MilestoneAVM!
	private var currentIndex = 0
	private var currentMilestone:MilestoneVM!
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

	@discardableResult
	func setup(with vm:MilestoneAVM,
			   _ currentMilestone:MilestoneVM,
			   _ tap: ((Int)->Void)? = nil) -> PagingCell {
		milestoneVM = vm
		self.currentMilestone = currentMilestone
		tapBlock = tap
		titleLabel.text = "Milestones"
		collectionView.register(UINib(resource: R.nib.milestoneCell),
								forCellWithReuseIdentifier: R.nib.milestoneCell.identifier)
		pageControl.numberOfPages = vm.numberOfItems

		for i in 0..<vm.numberOfItems {
			let s = vm.item(at: i)
			if s.model?.id == currentMilestone.model?.id { currentIndex = i }
		}

		pageControl.currentPage = currentIndex
		collectionView.reloadData()

		if vm.numberOfItems > currentIndex {
			collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0),
										at: .left,
										animated: false)
			collectionView.collectionViewLayout.invalidateLayout()
		}
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
		return faqVM?.numberOfItems ?? milestoneVM.numberOfItems
	}

	func collectionView(_ collectionView: UICollectionView,
						cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if faqVM != nil {
			return collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.faqCell,
													  for: indexPath)!
				.setup(with: faqVM.item(at: indexPath.item))
		}
		else {
			return collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.milestoneCell,
													  for: indexPath)!
				.setup(with: milestoneVM.item(at: indexPath.item))
		}
	}

	func collectionView(_ collectionView: UICollectionView,
						willDisplay cell: UICollectionViewCell,
						forItemAt indexPath: IndexPath) {
		let index = indexPath.item
		pageControl.currentPage = index

		if milestoneVM != nil {
			switch index {
			case 0..<currentIndex:
				titleLabel.text = "Previous milestone"
			case currentIndex:
				titleLabel.text = "Current milestone"
			case currentIndex + 1:
				titleLabel.text = "Next milestone"
			default:
				titleLabel.text = "Future milestone"
			}
		}
	}
}

extension PagingCell: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView,
						didSelectItemAt indexPath: IndexPath) {
		tapBlock?(indexPath.item)
	}
}
