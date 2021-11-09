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
    let fullName: String
    let language: String?
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let owner: Owner
    
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case language
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case owner
    }
}

struct Owner: Decodable {
    let avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
    }
}
