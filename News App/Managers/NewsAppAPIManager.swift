//
//  NewsAppAPIManager.swift
//  News App
//
//  Created by SK on 17/11/18.
//  Copyright © 2018 SK. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import SVProgressHUD


typealias SuccessBlock = ([String: Any]) -> Void
typealias ErrorBlock = (Error) -> Void

class NewsAppAPIManager {
    
    enum EndPoint: String {
        case newsSources = "sources"
        case topHeadlines = "top-headlines"

        var url: String {
            return "\(AppConfiguration.baseUrl)\(self.rawValue)"
        }
    }
}

extension NSError {
    
    convenience init(localizedDescription: String) {
        self.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }
    
    convenience init(code: Int, localizedDescription: String) {
        self.init(domain: "", code: code, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }
}

extension NewsAppAPIManager {
    
    static func getNewsSources(withParameters parameters: [String: Any], success : @escaping ([String: Any]) -> Void, failure : @escaping (Error) -> Void) {
        get(urlString: EndPoint.newsSources.url, parameters: parameters, success: success, failure: failure)
    }
    
    static func getTopHeadlines(withParameters parameters: [String: Any], success : @escaping ([String: Any]) -> Void, failure : @escaping (Error) -> Void) {
        get(urlString: EndPoint.topHeadlines.url, parameters: parameters, success: success, failure: failure)
    }
}

extension NewsAppAPIManager {
    
    private static func get(urlString: String,
                            parameters: [String : Any] = [:],
                            headers: [String : Any] = [:],
                            success : @escaping ([String: Any]) -> Void,
                            failure : @escaping (Error) -> Void) {
        request(urlString: urlString, httpMethod: .get, parameters: parameters, headers: headers, success: success, failure: failure)
    }
    
    private static func request(urlString: String,
                                httpMethod: HTTPMethod,
                                parameters: [String : Any] = [:],
                                headers: [String : Any] = [:],
                                success : @escaping ([String: Any]) -> Void,
                                failure : @escaping (Error) -> Void) {
        var additionalHeaders: HTTPHeaders?
        additionalHeaders = headers as? HTTPHeaders
        var requestParameters = parameters
        requestParameters[NewsApp.ApiKey.apiKey] = AppConfiguration.apiKey
        SVProgressHUD.show()
        Alamofire.request(urlString, method: httpMethod,
                          parameters: requestParameters, encoding: URLEncoding.default,
                          headers: additionalHeaders).responseJSON { (response: DataResponse<Any>) in
                            parseResponse(response, success: success, failure: failure)
        }
    }
    
    private static func parseResponse(_ response: DataResponse<Any>,
                                      success : @escaping ([String: Any]) -> Void,
                                      failure : @escaping (Error) -> Void) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
        switch response.result {
        case .success(let value):
            if let response = value as? [String: Any], let status = response["status"] as? String {
                if status == "ok" {
                    success(response)
                } else {
                    failure(NSError(localizedDescription: response["message"] as? String ?? ""))
                }
            } else {
                failure(NSError(localizedDescription: "Something went wrong!"))
            }
        case .failure(let e):
            let err = (e as NSError)
            if err.code == NSURLErrorNotConnectedToInternet || err.code == NSURLErrorInternationalRoamingOff {
                let internetNotAvailableError = NSError(code: NSURLErrorNotConnectedToInternet, localizedDescription: NewsApp.AlertMessage.noInternet)
                failure(internetNotAvailableError)
            } else {
                failure(e)
            }
        }
    }
}
