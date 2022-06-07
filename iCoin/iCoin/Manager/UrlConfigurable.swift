//
//  UrlConfigurable.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/07.
//

import Foundation

protocol UrlConfigurable {
    
}

extension UrlConfigurable {
    /// Try to create url for endpoint
    /// - Parameters:
    ///   - endpoint: Endpoint to create for
    ///   - queryParams: Additional query arguments
    /// - Returns: Optional URL
    func url(for baseUrl: String, queryParams: [String: String] = [:], with apiKey: [String : String]) -> URL? {
        var urlString = baseUrl
        
        var queryItems = [URLQueryItem]()
        // Add any parameters
        for (name, value) in queryParams {
            queryItems.append(.init(name: name, value: value))
        }
        
        // Add token
        queryItems.append(.init(name: "\(apiKey.keys.first ?? "")", value: "\(apiKey.values.first ?? "")"))
        
        // Convert queri items to suffix string
        urlString += "?" + queryItems.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
        
        print(urlString)
        
        return URL(string: urlString)
    }
}
