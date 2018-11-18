//
//  ViewController.swift
//  News App
//
//  Created by SK on 16/11/18.
//  Copyright © 2018 SK. All rights reserved.
//

import UIKit

class NewsSourcesViewController: UIViewController {

    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.placeholder = NewsApp.PlaceholderText.searchByName
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: NewsSourcesTableViewCell.self)
            tableView.tableFooterView = UIView()
        }
    }
    
    private var country = "", language = "", category = ""
    private var newsSources = [NewsSource]()
    private var searchedNewsSources = [NewsSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getNewsSources()
        addRefreshControl(tableView, selector: #selector(refreshControl(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = NewsApp.NavigationTitle.newsSources
    }
    
    @IBAction func filter(_ sender: Any) {
        view.endEditing(true)
        
        DispatchQueue.main.async {
            self.present(FilterViewController(country: self.country, language: self.language, category: self.category, filterData: { (country, language, category) in
                self.getNewsSources(with: country, language: language, category: category)
            }), animated: true, completion: nil)
        }
    }
    
    @objc private func refreshControl(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        getNewsSources()
    }
    
    private func getNewsSources(with country: String, language: String, category: String) {
        self.country = country
        self.language = language
        self.category = category
        getNewsSources()
    }
    
    private func getNewsSources() {
        NewsAppAPIManager.getNewsSources(withParameters: [NewsApp.ApiKey.country: country, NewsApp.ApiKey.language: language, NewsApp.ApiKey.category: category], success: { (response) in
            self.handleSuccessResponse(response: response)
        }) { (error) in
            self.alert(message: error.localizedDescription)
        }
    }
    
    private func handleSuccessResponse(response: [String: Any]) {
        if let sources = response[NewsApp.ApiKey.sources] as? [[String: Any]] {
            newsSources = NewsSource.parseNewsSources(sources)
            searchedNewsSources = newsSources
            tableView.reloadData()
        }
    }
    
    private func filterForSearchText(searchText: String) {
        searchedNewsSources = searchText.isEmpty ?
            newsSources :
            newsSources.filter({
                return $0.name.lowercased().contains(searchText.lowercased())
            })
        tableView.reloadData()
    }
}

extension NewsSourcesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedNewsSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: NewsSourcesTableViewCell.self)
        
        let newsSource = searchedNewsSources[indexPath.row]
        
        cell.nameLabel.text = newsSource.name
        cell.descriptionLabel.text = newsSource.description
        
        return cell
    }
}

extension NewsSourcesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
        
        let controller = TopHeadlinesViewController.instantiate(fromAppStoryboard: .Main)
        controller.newsSource = searchedNewsSources[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension NewsSourcesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterForSearchText(searchText: searchText.trimmingCharacters(in: .whitespaces))
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}


