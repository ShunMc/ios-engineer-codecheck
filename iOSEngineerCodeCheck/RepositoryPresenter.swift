//
//  RepositoryPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by Matsunobu Shun on 2021/10/19.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

class SearchRepositoryPresenter: SearchPresenter {
    
    private let searchUrl = "https://api.github.com/search/repositories?q=";
    
    private var repositories: [Repository] = []
    private var results: [SearchResult] = []
    
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
        if searchText.count == 0 {
            return
        }
        
        guard let encodedWord = searchText.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let url = URL(string:"\(searchUrl)\(encodedWord)"),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let repositories = try? JSONDecoder().decode(Repositories.self, from: data) else {
                  return
              }
        self.repositories = repositories.items
        
        results = []
        for repository in self.repositories
        {
            results.append(SearchResult(title: repository.full_name, detail: repository.language ?? ""))
        }
    }
    
}
