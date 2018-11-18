//
//  NewsApp+Constant.swift
//  News App
//
//  Created by SK on 16/11/18.
//  Copyright © 2018 SK. All rights reserved.
//

import Foundation


enum NewsApp {
    
    struct PlaceholderText {
        static let searchByName = "Search by name"
     }
    
    struct AlertMessage {
        static let noInternet = "No Internet connection available. Please connect to internet and try again."
    }
    
    struct NavigationTitle {
        static let newsSources = "News Sources"
        static let topHeadlines = "Top Headlines"
    }
    
    struct ApiKey {
        static let language = "language"
        static let country = "country"
        static let apiKey = "apiKey"
        static let sources = "sources"
        static let category = "category"
        static let articles = "articles"
    }
    
    struct Filter {
        static let categories = ["Business", "Entertainment", "General", "Health", "Science", "Sports", "Technology"]
        static let languages = ["AR", "DE", "EN", "ES", "FR", "HE", "IT", "NL", "NO", "PT", "RU", "SE", "UD", "ZH"]
        static let countries = ["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn", "co", "cu", "cz", "de",
                                "eg", "fr", "gb", "gr", "hk", "hu", "id", "ie", "il", "in", "it", "jp", "kr", "lt",
                                "lv", "ma", "mx", "my", "ng", "nl", "no", "nz", "ph", "pl", "pt", "ro", "rs", "ru",
                                "sa", "se", "sg", "si", "sk", "th", "tr", "tw", "ua", "us", "ve", "za"]
    }
}
