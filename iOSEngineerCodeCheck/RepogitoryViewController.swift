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
        
        let repo = searchVC.repogitories[searchVC.selectedIndex]
        
        languageLabel.text = "Written in \(repo["language"] as? String ?? "")"
        starsCountLabel.text = "\(repo["stargazers_count"] as? Int ?? 0) stars"
        watchersCountLabel.text = "\(repo["wachers_count"] as? Int ?? 0) watchers"
        forksCountLabel.text = "\(repo["forks_count"] as? Int ?? 0) forks"
        issuesCountLabel.text = "\(repo["open_issues_count"] as? Int ?? 0) open issues"
        Task{
            try await getImage()
        }
    }
    
    func getImage() async throws {
        let repo = searchVC.repogitories[searchVC.selectedIndex]
        
        repogitoryNameLabel.text = repo["full_name"] as? String
        
        guard let owner = repo["owner"] as? [String: Any] else {
            return
        }
        guard let imgURL = owner["avatar_url"] as? String else {
            return
        }
        
        let (data, _)  = try await URLSession.shared.data(from: URL(string: imgURL)!)
        let img = UIImage(data: data)
        DispatchQueue.main.async {
            self.thumbnailImageView.image = img
        }
    }
    
}
