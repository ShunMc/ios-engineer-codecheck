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
    
    var vc1: SearchViewController!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let repogitory = vc1.repogitories[vc1.selectedIndex]
        
        languageLabel.text = "Written in \(repogitory["language"] as? String ?? "")"
        starsCountLabel.text = "\(repogitory["stargazers_count"] as? Int ?? 0) stars"
        watchersCountLabel.text = "\(repogitory["wachers_count"] as? Int ?? 0) watchers"
        forksCountLabel.text = "\(repogitory["forks_count"] as? Int ?? 0) forks"
        issuesCountLabel.text = "\(repogitory["open_issues_count"] as? Int ?? 0) open issues"
        getImage()
        
    }
    
    func getImage(){
        
        let repogitory = vc1.repogitories[vc1.selectedIndex]
        
        repogitoryNameLabel.text = repogitory["full_name"] as? String
        
        if let owner = repogitory["owner"] as? [String: Any] {
            if let imgURL = owner["avatar_url"] as? String {
                URLSession.shared.dataTask(with: URL(string: imgURL)!) { (data, res, err) in
                    let img = UIImage(data: data!)!
                    DispatchQueue.main.async {
                        self.thumbnailImageView.image = img
                    }
                }.resume()
            }
        }
        
    }
    
}
