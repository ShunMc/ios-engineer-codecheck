//
//  RepositoryPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by Matsunobu Shun on 2021/10/19.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

class RepositoryPresenter {
    
    private let searchUrl = "https://api.github.com/search/repositories?q=";
    
    var repositories: [Repository] = []
    
    func request(_ searchWord: String) async {
        if searchWord.count == 0 {
            return
        }
        
        guard let encodedWord = searchWord.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let url = URL(string:"\(searchUrl)\(encodedWord)"),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let repositories = try? JSONDecoder().decode(Repositories.self, from: data) else {
                  return
              }
        self.repositories = repositories.items
    }
    
}
