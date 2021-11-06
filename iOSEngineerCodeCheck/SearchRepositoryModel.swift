//
//  SearchRepositoryModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Matsunobu Shun on 2021/11/04.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

class SearchRepositoryModel: SearchRepositoryModelProtocol {
    
    private let searchUrl = "https://api.github.com/search/repositories?q=";
    
    enum SearchError: Error {
        case TextEmpty
        case EncodeFailed
        case URLInvalid
    }
    
    func fetch(_ searchText: String) async throws -> (repositories: [Repository], results: [SearchResult]) {
        if searchText.count == 0 {
            throw SearchError.TextEmpty
        }
        
        guard let encodedWord = searchText.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw SearchError.EncodeFailed
        }
        guard let url = URL(string:"\(searchUrl)\(encodedWord)") else {
            throw SearchError.URLInvalid
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let repositories = try JSONDecoder().decode(Repositories.self, from: data)
        
        var results = [SearchResult]()
        for repository in repositories.items
        {
            results.append(SearchResult(title: repository.full_name, detail: repository.language ?? ""))
        }
        
        return (repositories.items, results)
    }
}
