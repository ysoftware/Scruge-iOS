//
//  ExtendableView.swift
//  Ysoftware
//
//  Created by Yaroslav Erohin on 27.12.16.
//  Copyright © 2016 Yaroslav Erohin. All rights reserved.
//

import UIKit

enum ExpandableViewState {
    /// The view is `expanded` and showing both firstView and secondView.
    case expanded
    /// The view is `collapsed` and only showing firstView.
    case collapsed
    /// The view is currently `animating` the change of state.
    case animating
}

/// Implement this protocol and set your class as this view's delegate to receive calls about change of this view's state.
protocol ExpandableViewDelegate: class {
    /// Called right after expandableView finishes animating its state change.
    /// - parameter sender: Instance of `ExpandableView` that issued this call.
    /// - parameter isOpened: Current state of view.
    func expandableView(_ sender: ExpandableView, didChangeTo state: ExpandableViewState)
    /// Called right before expandableView changes its state.
    /// - parameter sender: Instance of `ExpandableView` that issued this call.
    /// - parameter isOpened: New state of view.
    func expandableView(_ sender: ExpandableView, willChangeTo state: ExpandableViewState)
}

/// this extension makes ExpandableViewDelegate methods optional.
extension ExpandableViewDelegate {
    func expandableView(_ sender: ExpandableView, didChangeTo state: ExpandableViewState) { }
    func expandableView(_ sender: ExpandableView, willChangeTo state: ExpandableViewState) { }
}

/// You need to create a View object in your Storyboard and set it's class to `ExpandableView`.
///
/// Then create 2 UIView objects inside of it, create a height constraints for each and connect them as `firstView` and `secondView`.
///
/// This class creates constraints for `firstView` and `secondView`. You should not add them.
///
/// *If you don't want to have any warning inside of your Interface Builder, you can add all constraints you need and set them to remove at build time.*
///
/// Done. You can tap your expandableView or use `expand()` and `collapse()` methods to change its state.
@available (iOS 7, *) final class ExpandableView: UIView {

    // MARK: - Outlets

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!

    // MARK: - Private

    override func awakeFromNib() {
        super.awakeFromNib()

        clipsToBounds = true
        backgroundColor = .clear // if you want, you'll need to change background color in the code after the view is initialized
        isUserInteractionEnabled = true

        firstView.addGestureRecognizer(UITapGestureRecognizer(target: self,
															  action: #selector(didReceiveTap(_:))))

        // setup constraints for firstView and secondView (except height)
		self.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let margins = self.layoutMarginsGuide

        firstView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        firstView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        firstView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
		firstView.bottomAnchor.constraint(equalTo: secondView.topAnchor).isActive = true
        secondView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        secondView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true

        heightConstraint = self.heightAnchor.constraint(equalToConstant: firstView.frame.height)
        heightConstraint.isActive = true
    }

    /// animates change of state
    private func change(to state:ExpandableViewState) {
        guard state != self.state else { return }

        self.delegate?.expandableView(self, willChangeTo: state)
		let secondViewHeight = (state == .expanded ? secondView.frame.height : 0)
        self.heightConstraint.constant = firstView.frame.height + secondViewHeight
        self.state = .animating

        UIView.animate(withDuration: animationTime,
                       delay: animationDelay,
                       usingSpringWithDamping: springDamping,
                       initialSpringVelocity: initialSpringVelocity,
                       options: animationOptions,
                       animations: {
                        self.layoutIfNeeded()
        }) { _ in
            self.state = state
            self.delegate?.expandableView(self, didChangeTo: state)
        }
    }

    /// method for tap gesture recognizer
    @objc private func didReceiveTap(_ sender:UITapGestureRecognizer) {
        if !shouldIgnoreTap && state != .animating {
            change(to: state == .collapsed ? .expanded : .collapsed)
        }
    }

    // MARK: - Properties

    private var heightConstraint:NSLayoutConstraint!

    /// Set your `ExpandableViewDelegate` compliant object as a delegate to receive calls about change of this view's state.
    weak var delegate:ExpandableViewDelegate?

    /// Check this property for view's state. Get only.
    ///
    /// To change state, use `expand()`, `collapse()` or `toggle()` methods.
    public private(set) var state:ExpandableViewState = .collapsed

    // MARK: - Customization

    /// Time of animation for change of state.
    ///
    /// Measured in seconds. Default is `0.5`.
    var animationTime:TimeInterval = 0.5

    /// Delay before animation.
    ///
    /// Measured in seconds. Default is 0.
    var animationDelay:TimeInterval = 0

    /// The damping ratio for the spring animation as it approaches its quiescent state.
    /// To smoothly decelerate the animation without oscillation, use a value of 1. Employ a damping ratio closer to zero to increase oscillation.
    ///
    /// Default is `0`.
    var springDamping:CGFloat = 0

    /// The initial spring velocity. For smooth start to the animation, match this value to the view’s velocity as it was prior to attachment.
    ///
    /// A value of 1 corresponds to the total animation distance traversed in one second. For example, if the total animation distance is 200 points and you want the start of the animation to match a view velocity of 100 pt/s, use a value of 0.5.
    ///
    /// Default is `0`.
    var initialSpringVelocity:CGFloat = 0

    /// A mask of options indicating how you want to perform the animations.
    ///
    /// Default is linear (`.curveLinear`).
	var animationOptions:UIView.AnimationOptions = .curveLinear

    /// Set this to true if you want this view to ignore user's tap.
    ///
    /// Default is `false`.
    var shouldIgnoreTap = false

    // MARK: - Methods

    /// Call this method to animate view to `expanded` state.
    ///
    /// Ignored if it's already `expanded`.
    func expand() {
        if state == .collapsed {
            change(to: .expanded)
        }
    }

    /// Call this method to animate view to `collapsed` state.
    ///
    /// Ignored if it's already `collapsed`.
    func collapse() {
        if state == .expanded {
            change(to: .collapsed)
        }
    }

    /// Call this method to change the view's state.
    ///
    /// If `collapsed`, this will call `expand()`.
    /// If `expanded`, this will call `collapse()`.
    /// Ignored if `animating`.
    func toggle() {
        switch state {
        case .collapsed: expand()
        case .expanded: collapse()
        default: break
        }
    }
}
