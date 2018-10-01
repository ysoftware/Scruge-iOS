//
//  CommentAVM.swift
//  Scruge
//
//  Created by ysoftware on 26/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM
import Result

final class CommentAVM: ArrayViewModel<Comment, CommentVM, CommentQuery> {

	let source:CommentSource?

	init(source:CommentSource) {
		self.source = source
	}

	init(_ comments:[Comment]) {
		source = nil
		super.init()
		manageItems(comments)
	}

	override func fetchData(_ query: CommentQuery?,
							_ block: @escaping (Result<[Comment], AnyError>) -> Void) {
		guard let source = source else { return }
		switch source {
		case .campaign(let campaign):
			Service.api.getComments(for: campaign) { self.handleResponse($0, block) }
		case .update(let update):
			Service.api.getComments(for: update) { self.handleResponse($0, block) }
		}
	}

	func handleResponse(_ result:Result<CommentListResponse, AnyError>,
						_ block: (Result<[Comment], AnyError>) -> Void) {

		switch result {
		case .success(let response):
			block(.success(response.data))
		case .failure(let error):
			block(.failure(error))
		}
	}
}
