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

class SearchViewController: UITableViewController {
    
    private var presenter: SearchPresenter!
    
    func inject(presenter: SearchPresenter) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inject(presenter: SearchRepositoryPresenter())
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let searchBar = UISearchBar()
        searchBar.placeholder = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
        return searchBar
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfElement
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = presenter.getElement(at: indexPath.row)
        let cell = UITableViewCell()
        cell.textLabel?.text = result.title
        cell.detailTextLabel?.text = result.detail
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = presenter.didSelectRow(at: indexPath.row)
        self.navigationController?.pushViewController(vc, animated: true)
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
