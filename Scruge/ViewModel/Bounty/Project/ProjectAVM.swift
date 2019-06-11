//
//  ProjectAVM.swift
//  Scruge
//
//  Created by ysoftware on 15/02/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import MVVM

final class ProjectsAVM: ArrayViewModel<Project, ProjectVM, ProjectQ> {

	override func fetchData(_ query: ProjectQ?, _ block: @escaping (Result<[Project], Error>) -> Void) {
		Service.api.getProjects  { block($0.map { $0.projects }) }
	}
}
