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

	let source:CommentSource

	init(source:CommentSource) {
		self.source = source
	}

	override func fetchData(_ query: CommentQuery?,
							_ block: @escaping (Result<[Comment], AnyError>) -> Void) {
		let api = Api()
		switch source {
		case .campaign(let campaign):
			api.getComments(for: campaign) { self.completion($0, block) }
		case .update(let update):
			api.getComments(for: update) { self.completion($0, block) }
		}
	}

	func completion(_ result:Result<CommentListResponse, NetworkingError>,
					_ block: (Result<[Comment], AnyError>) -> Void) {

		switch result {
		case .success(let response):
			block(.success(response.data))
		case .failure(let error):
			block(.failure(AnyError(error)))
		}
	}
}
