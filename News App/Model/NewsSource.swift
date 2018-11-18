//
//  NewsSource.swift
//  News App
//
//  Created by SK on 17/11/18.
//  Copyright © 2018 SK. All rights reserved.
//

import Foundation
import ObjectMapper

class NewsSource: Mappable {
    
    var id = ""
    var name = ""
    var description = ""
    var url = ""
    var category = ""
    var language = ""
    var country = ""
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        description <- map["description"]
        url <- map["url"]
        category <- map["category"]
        language <- map["language"]
        country <- map["country"]
    }
    
    static func parseNewsSources(_ arrayDict: [[String: Any]]) -> [NewsSource] {
        var newsSources = [NewsSource]()
        for dict in arrayDict {
            if let newsSource = Mapper<NewsSource>().map(JSON: dict) {
                newsSources.append(newsSource)
            }
        }
        
        return newsSources
    }
}
