//
//  CommentsVC.swift
//  Scruge
//
//  Created by ysoftware on 03/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import MVVM

final class CommentsViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var commentInputView: UIVisualEffectView!
	@IBOutlet weak var commentField: UITextField!
	@IBOutlet weak var inputBottomConstraint: NSLayoutConstraint!
	
	// MARK: - Actions

	@IBAction func sendComment(_ sender: Any) {
	}

	// MARK: - Properties

	public var vm:CommentAVM!

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		setupTableView()
		setupVM()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupKeyboard()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(self)
	}

	private func setupVM() {
		vm.delegate = self
		vm.reloadData()
	}

	private func setupKeyboard() {
		setKeyboard(open: false, with: nil)

		NotificationCenter.default.addObserver(forName: UIWindow.keyboardWillShowNotification,
											   object: nil,
											   queue: .main) { [weak self] notification in
												self?.setKeyboard(open: true, with: notification)
		}
		NotificationCenter.default.addObserver(forName: UIWindow.keyboardWillHideNotification,
											   object: nil,
											   queue: .main) { [weak self] notification in
												self?.setKeyboard(open: false, with: notification)
		}
	}

	private func setupTableView() {
		tableView.estimatedRowHeight = 80
		tableView.rowHeight = UITableView.automaticDimension
		tableView.register(UINib(resource: R.nib.commentCell),
						   forCellReuseIdentifier: R.reuseIdentifier.commentCell.identifier)
	}

	private func setKeyboard(open:Bool, with notification:Notification?) {

		// input view inset
		if open, let notification = notification {
			guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
				else { return }
			inputBottomConstraint.constant = frame.cgRectValue.height
		}
		else {
			inputBottomConstraint.constant = 0
		}

		if let notification = notification {
			guard
				let info = notification.userInfo,
				let curve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
				let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
				else { return }

			let options = UIView.AnimationOptions(rawValue: curve)
			UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
				self.view.layoutIfNeeded()
			})
		}
	}
}

extension CommentsViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return vm.numberOfItems
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.commentCell,
											 for: indexPath)!
			.setup(with: vm.item(at: indexPath.row))
	}
}

extension CommentsViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

extension CommentsViewController: ArrayViewModelDelegate {

	func didUpdateData<M, VM, Q>(_ arrayViewModel: ArrayViewModel<M, VM, Q>, _ update: MVVM.Update)
		where M : Equatable, VM : ViewModel<M>, Q : Query {
			tableView.reloadData()
	}

	func didChangeState(to state: ArrayViewModelState) {

	}
}
