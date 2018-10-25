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
	@IBOutlet weak var loadingView: LoadingView!
	@IBOutlet weak var commentActivity: UIActivityIndicatorView!
	@IBOutlet weak var sendButton: UIButton!

	// MARK: - Actions

	@IBAction func sendComment(_ sender: Any) {
		guard let comment = comment else { return alert("Message is too short") }
		
		commentActivity.isHidden = false
		sendButton.isHidden = true

		vm.postComment(comment) { success in
			self.commentActivity.isHidden = true
			self.sendButton.isHidden = false

			if success {
				self.view.endEditing(true)
				self.setKeyboard(height: 0)
				self.commentField.text = ""
				self.reloadData()
			}
			else {
				#warning("some error, did not send")
			}
		}
	}

	// MARK: - Properties

	public var vm:CommentAVM!

	private var comment:String? {
		let string = (commentField.text ?? "").trimmingCharacters(in: .whitespaces)
		if string.count < 3 {
			return nil
		}
		return string
	}

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		setupTableView()
		setupVM()
		setupInputBar()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupKeyboard()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(self)
	}

	private func setupInputBar() {
		commentActivity.isHidden = true
		sendButton.isHidden = false
		commentField.delegate = self
	}

	private func setupVM() {
		vm.delegate = self
		reloadData()
	}

	private func setupKeyboard() {
		setKeyboard(height: 0)

		NotificationCenter.default.addObserver(forName: UIWindow.keyboardWillShowNotification,
											   object: nil,
											   queue: .main) { [weak self] notification in
												self?.setKeyboard(with: notification)
		}
		NotificationCenter.default.addObserver(forName: UIWindow.keyboardWillHideNotification,
											   object: nil,
											   queue: .main) { [weak self] notification in
												self?.setKeyboard(with: notification)
		}
	}

	private func setupTableView() {
		tableView.refreshControl = UIRefreshControl()
		tableView.refreshControl!.addTarget(self, action: #selector(reloadData), for: .valueChanged)

		tableView.estimatedRowHeight = 80
		tableView.rowHeight = UITableView.automaticDimension
		tableView.register(UINib(resource: R.nib.commentCell),
						   forCellReuseIdentifier: R.reuseIdentifier.commentCell.identifier)
	}

	@objc func reloadData() {
		vm.reloadData()
	}

	// MARK: - Keyboard
	
	private func setKeyboard(with notification:Notification) {
		guard let frame = notification.userInfo?[UIViewController.keyboardFrameEndUserInfoKey] as? NSValue
			else { return }
		setKeyboard(height: frame.cgRectValue.height)

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

	private func setKeyboard(height:CGFloat) {
		inputBottomConstraint.constant = height
	}
}

extension CommentsViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return vm.numberOfItems
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.commentCell,
											 for: indexPath)!
			.setup(with: vm.item(at: indexPath.row, shouldLoadMore: true))
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

	func didChangeState<M, VM, Q>(_ arrayViewModel: ArrayViewModel<M, VM, Q>,
								  to state: ArrayViewModelState)
		where M : Equatable, VM : ViewModel<M>, Q : Query {
		
		switch state {
		case .initial:
			loadingView.set(state: .loading)
		case .error(let error):
			let message = ErrorHandler.message(for: error)
			loadingView.set(state: .error(message))

			tableView.refreshControl?.endRefreshing()
		case .ready:
			if vm.isEmpty {
				loadingView.set(state: .error("No comments"))
			}
			else {
				loadingView.set(state: .ready)
			}
			tableView.refreshControl?.endRefreshing()
		default: break
		}
	}
}

extension CommentsViewController: UITextFieldDelegate {

	func textField(_ textField: UITextField,
				   shouldChangeCharactersIn range: NSRange,
				   replacementString string: String) -> Bool {

		guard let text = textField.text else { return true }
		let newLength = text.count + string.count - range.length

		if textField == commentField {
			return newLength <= 599
		}
		return true
	}
}
