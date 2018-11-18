//
//  Article.swift
//  News App
//
//  Created by SK on 18/11/18.
//  Copyright © 2018 SK. All rights reserved.
//

import Foundation
import ObjectMapper

class Article: Mappable {
    
    var id = ""
    var author = ""
    var title = ""
    var description = ""
    var url = ""
    var urlToImage = ""
    var publishedAt = ""
    var content = ""
    var source: NewsSource?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        author <- map["author"]
        title <- map["title"]
        description <- map["description"]
        url <- map["url"]
        urlToImage <- map["urlToImage"]
        publishedAt <- map["publishedAt"]
        content <- map["content"]
        source <- map["source"]
    }
    
    static func parseArticles(_ arrayDict: [[String: Any]]) -> [Article] {
        var articles = [Article]()
        for dict in arrayDict {
            if let article = Mapper<Article>().map(JSON: dict) {
                articles.append(article)
            }
        }
        
        return articles
    }
}
