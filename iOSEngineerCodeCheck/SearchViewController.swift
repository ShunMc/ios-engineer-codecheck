//
//  SearchViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

struct SearchResult {
    var title: String
    var detail: String
    
    init(title: String, detail: String)
    {
        self.title = title
        self.detail = detail
    }
}

protocol SearchPresenter {
    var numberOfElement: Int { get }
    func update(_ searchText: String) async
    func getElement(at index: Int) -> SearchResult
    func didSelectRow(at: Int) -> UIViewController
}

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var presenter: SearchPresenter!
    
    func inject(presenter: SearchPresenter) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let model = SearchRepositoryModel()
        let presenter = SearchRepositoryPresenter(model: model)
        inject(presenter: presenter)
        
        searchBar.placeholder = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = presenter.didSelectRow(at: indexPath.row)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfElement
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = presenter.getElement(at: indexPath.row)
        let cell = UITableViewCell()
        cell.textLabel?.text = result.title
        cell.detailTextLabel?.text = result.detail
        return cell
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 必ず存在する
        let searchWord = searchBar.text!

        Task {
            await presenter.update(searchWord)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}
