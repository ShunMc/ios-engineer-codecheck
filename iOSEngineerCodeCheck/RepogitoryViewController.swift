//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepogitoryViewController: UIViewController {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var repogitoryNameLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var watchersCountLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    @IBOutlet weak var issuesCountLabel: UILabel!
    
    var searchVC: SearchViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let repo = searchVC.repogitory
        
        repogitoryNameLabel.text = repo.full_name
        if let language = repo.language {
            languageLabel.text = "Written in \(language)"
        }
        starsCountLabel.text = "\(repo.stargazers_count) stars"
        watchersCountLabel.text = "\(repo.watchers_count) watchers"
        forksCountLabel.text = "\(repo.forks_count) forks"
        issuesCountLabel.text = "\(repo.open_issues_count) open issues"
        Task{
            try await getImage()
        }
    }
    
    func getImage() async throws {
        let repo = searchVC.repogitory
        let owner = repo.owner
        guard let imgURL = URL(string: owner.avatar_url) else {
            return
        }
        
        let (data, _)  = try await URLSession.shared.data(from: imgURL)
        let img = UIImage(data: data)
        DispatchQueue.main.async {
            self.thumbnailImageView.image = img
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.thumbnailImageView.image = nil;
        self.thumbnailImageView.layer.sublayers = nil;
        self.thumbnailImageView = nil;
    }
    
}
