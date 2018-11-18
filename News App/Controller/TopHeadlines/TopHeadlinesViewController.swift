//
//  TopHeadlinesViewController.swift
//  News App
//
//  Created by SK on 18/11/18.
//  Copyright © 2018 SK. All rights reserved.
//

import UIKit
import Kingfisher

class TopHeadlinesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: TopHeadlinesTableViewCell.self)
            tableView.tableFooterView = UIView()
        }
    }
    
    var newsSource = NewsSource()
    var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTopHeadlines()
        addRefreshControl(tableView, selector: #selector(refreshControl(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = newsSource.name
    }
    
    @objc private func refreshControl(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        getTopHeadlines()
    }
    
    private func getTopHeadlines() {
        NewsAppAPIManager.getTopHeadlines(withParameters: [NewsApp.ApiKey.sources: newsSource.id], success: { (response) in
            self.handleSuccessResponse(response: response)
        }) { (error) in
            self.alert(message: error.localizedDescription)
        }
    }
    
    private func handleSuccessResponse(response: [String: Any]) {
        if let articles = response[NewsApp.ApiKey.articles] as? [[String: Any]] {
            self.articles = Article.parseArticles(articles)
            tableView.reloadData()
        }
    }
}

extension TopHeadlinesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: TopHeadlinesTableViewCell.self)
        
        let article = articles[indexPath.row]
        
        cell.articleTitleLabel.text = article.title
        cell.articleAuthorLabel.text = article.author
        cell.articleDescriptionLabel.text = article.description
        cell.articleDateLabel.text = article.publishedAt.getDateFormattedString()
        cell.articleImageView.image = nil
        if let imageUrl = URL(string: article.urlToImage) {
            cell.articleImageView.kf.indicatorType = .activity
            cell.articleImageView.kf.setImage(with: imageUrl, placeholder: nil, options: [KingfisherOptionsInfoItem.cacheMemoryOnly], progressBlock: nil, completionHandler: nil)
        }
        
        return cell
    }
}

extension TopHeadlinesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let url = NSURL(string: articles[indexPath.row].url) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
}
