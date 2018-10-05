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

	init(source:CommentSource) {
		super.init()
		self.query = CommentQuery(source: source, page: 0)
	}

	init(_ comments:[Comment], source:CommentSource) {
		super.init()
		self.query = CommentQuery(source: source, page: 0)
		setData(comments.map { CommentVM($0) })
	}

	override func fetchData(_ query: CommentQuery?,
							_ block: @escaping (Result<[Comment], AnyError>)->Void) {
		guard let query = query else { return block(.success([])) }

		Service.api.getComments(for: query) { result in
			switch result {
			case .success(let response):
				block(.success(response.data))
			case .failure(let error):
				block(.failure(error))
			}
		}
	}

	// MARK: - Methods

	func postComment(_ comment:String, _ completion: @escaping (Bool)->Void) {
		guard let source = query?.source else { return completion(false) }
		Service.api.postComment(comment, source: source) { result in
			switch result {
			case .success: completion(true)
			case .failure: completion(false)
			}
		}
	}
}
