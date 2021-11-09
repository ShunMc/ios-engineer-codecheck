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
        
        repositoryNameLabel.text = repository.fullName
        if let language = repository.language {
            languageLabel.text = "Written in \(language)"
        }
        starsCountLabel.text = "\(repository.stargazersCount) stars"
        watchersCountLabel.text = "\(repository.watchersCount) watchers"
        forksCountLabel.text = "\(repository.forksCount) forks"
        issuesCountLabel.text = "\(repository.openIssuesCount) open issues"
        Task{
            guard let image = await ImageUtil.download(by: repository.owner.avatarUrl) else {
                return
            }
            
            DispatchQueue.main.async {
                self.thumbnailImageView.image = image
            }
        }
    }
    
}
