//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var repogitories: [Repogitory]=[]
    
    var task: Task<Void, Error>?
    var selectedIndex: Int!
    
    let searchUrl = "https://api.github.com/search/repositories?q=";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        task?.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        task = Task {
            let searchWord = searchBar.text!
            
            if searchWord.count == 0 {
                return
            }

            guard let encodedWord = searchWord.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
                return
            }
            guard let url = URL(string:"\(searchUrl)\(encodedWord)") else {
                return
            }
            guard let (data, _) = try? await URLSession.shared.data(from: url) else {
                return
            }
            guard let repogitories = try? JSONDecoder().decode(Repogitories.self, from: data) else {
                return
            }
            self.repogitories = repogitories.items
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "Detail" {
            return
        }
        guard let dst = segue.destination as? RepogitoryViewController else {
            return
        }
        dst.searchVC = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repogitories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let repo = repogitories[indexPath.row]
        cell.textLabel?.text = repo.full_name
        cell.detailTextLabel?.text = repo.language
        cell.tag = indexPath.row
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
    
}
