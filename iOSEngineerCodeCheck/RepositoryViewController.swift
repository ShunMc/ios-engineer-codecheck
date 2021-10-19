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
        
        guard let repo = repository else {
            return
        }
        
        repositoryNameLabel.text = repo.full_name
        if let language = repo.language {
            languageLabel.text = "Written in \(language)"
        }
        starsCountLabel.text = "\(repo.stargazers_count) stars"
        watchersCountLabel.text = "\(repo.watchers_count) watchers"
        forksCountLabel.text = "\(repo.forks_count) forks"
        issuesCountLabel.text = "\(repo.open_issues_count) open issues"
        Task{
            guard let image = await getImage() else {
                return
            }
            DispatchQueue.main.async {
                self.thumbnailImageView.image = image
            }
        }
    }
    
    func getImage() async -> UIImage? {
        guard let repo = repository else {
            return nil
        }
        
        let owner = repo.owner
        guard let imgURL = URL(string: owner.avatar_url),
              let (data, _)  = try? await URLSession.shared.data(from: imgURL) else {
                  return nil
              }
        
        return UIImage(data: data)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.thumbnailImageView.image = nil;
        self.thumbnailImageView.layer.sublayers = nil;
        self.thumbnailImageView = nil;
    }
    
}
