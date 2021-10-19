//
//  SearchViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var repositoryPresenter: RepositoryPresenter = RepositoryPresenter()
    private var task: Task<Void, Error>?
    
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
            await repositoryPresenter.request(searchWord)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "Detail" {
            return
        }
        guard let dst = segue.destination as? RepositoryViewController,
              let repository = sender as? Repository else {
                  return
              }
        dst.repository = repository
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryPresenter.repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let repo = repositoryPresenter.repositories[indexPath.row]
        cell.textLabel?.text = repo.full_name
        cell.detailTextLabel?.text = repo.language
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Detail", sender: repositoryPresenter.repositories[indexPath.row])
    }
    
}
