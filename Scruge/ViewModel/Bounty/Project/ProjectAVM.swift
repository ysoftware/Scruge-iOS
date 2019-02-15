//
//  ProjectAVM.swift
//  Scruge
//
//  Created by ysoftware on 15/02/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import MVVM
import Result

final class ProjectsAVM: ArrayViewModel<Project, ProjectVM, ProjectQ> {

	override func fetchData(_ query: ProjectQ?, _ block: @escaping (Result<[Project], AnyError>) -> Void) {

	}
}
