//
//  GitHubRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by Matsunobu Shun on 2021/10/17.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

struct Repositories: Decodable {
    let items: [Repository]
}

struct Repository: Decodable {
    let full_name: String
    let language: String?
    let stargazers_count: Int
    let watchers_count: Int
    let forks_count: Int
    let open_issues_count: Int
    let owner: Owner
}

struct Owner: Decodable {
    let avatar_url: String
}
