//
//  NetworkManager.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/07.
//
import Combine
import Foundation

//MARK: - News API Key
//"https://min-api.cryptocompare.com/documentation"

protocol NetworkProtocol {
    func fetchNews(of symbol: String) -> AnyPublisher<NewsDataResponse, Error>
}

final class NetworkManager: NetworkProtocol, UrlConfigurable {
    private enum NewsConstants {
        static let apiKey = "508858945962b1d801891796a6d67f8076873f9996b13b48e5eb63030be21ec4"
        static let newsBaseUrl = "https://min-api.cryptocompare.com/data/v2/news/"
//                                "https://min-api.cryptocompare.com/data/v2/news/"
    }
    
    ///Perform News api call
    ///return AnyPublisher containing NewsDataResponse
    func fetchNews(of symbol: String = "") -> AnyPublisher<NewsDataResponse, Error> {
        let url = url(for: NewsConstants.newsBaseUrl, with: [
            "lang": "EN",
            "api_key": NewsConstants.apiKey
        ])
        print(url)
        return request(url: url, expecting: NewsDataResponse.self)
    }
    
    /// API Errors
    private enum APIError: Error {
        case noDataReturned
        case invalidUrl
    }
    
    /// Perform api call
    /// - Parameters:
    ///   - url: URL to hit
    ///   - expecting: Type we expect to decode data to
    ///   - completion: Result callback
    private func request<T: Codable>(url: URL?, expecting: T.Type) -> AnyPublisher<T, Error> {
        Future { promise in
            guard let url = url else { return
                promise(.failure( APIError.invalidUrl))}
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.failure(APIError.noDataReturned))
                    }
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(expecting, from: data)
                    promise(.success(result))
                }
                catch {
                    promise(.failure(error))
                }
            }
            .resume()
        }
        .eraseToAnyPublisher()
    }
}
