//
//  RepositoryViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import Instantiate
import InstantiateStandard

class RepositoryViewController: UIViewController, StoryboardInstantiatable {
    
    typealias Dependency = Repository
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var watchersCountLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    @IBOutlet weak var issuesCountLabel: UILabel!
    
    private var repository: Repository!
    
    func inject(_ dependency: Repository) {
        self.repository = dependency
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repositoryNameLabel.text = repository.full_name
        if let language = repository.language {
            languageLabel.text = "Written in \(language)"
        }
        starsCountLabel.text = "\(repository.stargazers_count) stars"
        watchersCountLabel.text = "\(repository.watchers_count) watchers"
        forksCountLabel.text = "\(repository.forks_count) forks"
        issuesCountLabel.text = "\(repository.open_issues_count) open issues"
        Task{
            guard let image = await ImageUtil.download(by: repository.owner.avatar_url) else {
                return
            }
            
            DispatchQueue.main.async {
                self.thumbnailImageView.image = image
            }
        }
    }
    
}
