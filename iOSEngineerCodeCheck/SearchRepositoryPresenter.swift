//
//  SearchRepositoryPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by Matsunobu Shun on 2021/10/19.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

protocol SearchRepositoryModelProtocol {
    func fetch(_ searchText: String) async throws -> (repositories: [Repository], results: [SearchResult])
}

class SearchRepositoryPresenter: SearchPresenter {
    
    private var repositories: [Repository] = []
    private var results: [SearchResult] = []
    private var model: SearchRepositoryModelProtocol
    
    init(model: SearchRepositoryModelProtocol) {
        self.model = model
    }
    
    var numberOfElement: Int {
        get { return repositories.count }
    }
    
    func getElement(at index: Int) -> SearchResult {
        return results[index]
    }
    
    func didSelectRow(at index: Int) -> UIViewController {
        return RepositoryViewController(with: repositories[index])
    }
    
    func update(_ searchText: String) async {
        guard let (repositories, results) = try? await model.fetch(searchText) else {
            return
        }
        self.repositories = repositories
        self.results = results
    }
    
}
