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
	private var didScroll = false

	@discardableResult
	func setup(with vm:FaqAVM) -> PagingCell {
		faqVM = vm
		titleLabel.text = "Frequently asked questions"
		collectionView.register(UINib(resource: R.nib.faqCell),
								forCellWithReuseIdentifier: R.nib.faqCell.identifier)
		pageControl.numberOfPages = vm.numberOfItems
		collectionView.reloadData()
		return self
	}

	@discardableResult
	func tap(_ tap: @escaping (Int)->Void) -> PagingCell {
		tapBlock = tap
		return self
	}

	@discardableResult
	func setup(with vm:MilestoneAVM,
			   _ currentMilestone:MilestoneVM) -> PagingCell {
		milestoneVM = vm
		self.currentMilestone = currentMilestone
		titleLabel.text = "Current milestone"
		collectionView.register(UINib(resource: R.nib.milestoneCell),
								forCellWithReuseIdentifier: R.nib.milestoneCell.identifier)
		pageControl.numberOfPages = vm.numberOfItems

		for i in 0..<vm.numberOfItems {
			let s = vm.item(at: i)
			if s.model?.id == currentMilestone.model?.id {
				currentIndex = i
			}
		}

		updateViews()

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			self.updateViews()
			if self.milestoneVM.numberOfItems > self.currentIndex, !self.didScroll {
				self.collectionView.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0),
												 at: .left,
												 animated: false)
			}
		}
		return self
	}

	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						sizeForItemAt indexPath: IndexPath) -> CGSize {
		return collectionView.bounds.size
	}

	private func updateViews() {
		guard let vm = milestoneVM else { return }
		pageControl.numberOfPages = vm.numberOfItems
		pageControl.currentPage = currentIndex
		collectionView.reloadData()
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
}

extension PagingCell: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView,
						didSelectItemAt indexPath: IndexPath) {
		tapBlock?(indexPath.item)
	}
}

extension PagingCell: UIScrollViewDelegate {

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let visiblePoint = CGPoint(x: collectionView.bounds.midX, y: collectionView.bounds.midY)
		if let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint) {
			let index = visibleIndexPath.row
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
}
