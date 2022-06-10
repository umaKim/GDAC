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
    func fetchCryptoCandle(of symbol: String) -> AnyPublisher<CryptoCandle, Error>
}

struct CryptoCandle: Codable {
      let c: [Double]?
      let h: [Double]?
      let l: [Double]?
      let o: [Double]?
      let t: [TimeInterval]?
}

//"/crypto/candle?symbol=BINANCE:BTCUSDT&resolution=D&from=1572651390&to=1575243390"

final class NetworkManager: NetworkProtocol, UrlConfigurable {
    
    private enum NewsConstants {
        static let apiKey = "508858945962b1d801891796a6d67f8076873f9996b13b48e5eb63030be21ec4"
        static let newsBaseUrl = "https://min-api.cryptocompare.com/data/v2/news/"
//                                "https://min-api.cryptocompare.com/data/v2/news/"
    }
    
    private enum CryptoCandleConstants {
        static let apiKey = "c3c6me2ad3iefuuilms0"
        static let cryptoCandleBaseUrl = "/crypto/candle"
    }
    
    private enum FinnHubApi {
        static let baseUrl = "https://finnhub.io/api/v1"
        static let day: TimeInterval = 3600 * 24
    }
    
    ///Perform News api call
    ///return AnyPublisher containing NewsDataResponse
    func fetchNews(of symbol: String = "") -> AnyPublisher<NewsDataResponse, Error> {
        let url = url(for: NewsConstants.newsBaseUrl, with: [
            "lang": "EN",
            "api_key": NewsConstants.apiKey
        ])
        return request(url: url, expecting: NewsDataResponse.self)
    }
    
    ///Perfom CryptoCandle API call
    ///return AnyPublisher cointaining CryptoCandle
    func fetchCryptoCandle(of symbol: String) -> AnyPublisher<CryptoCandle, Error> {
        let today = Date().addingTimeInterval(-(FinnHubApi.day))
        let prior = today.addingTimeInterval(-(FinnHubApi.day * 7))
        
        let url = url(for: FinnHubApi.baseUrl + CryptoCandleConstants.cryptoCandleBaseUrl,
                      queryParams: [
                        "symbol": "BINANCE:BTCUSDT",
                        "resolution": "D",
                        "from": "\(Int(today.timeIntervalSince1970))",
                        "to": "\(Int(prior.timeIntervalSince1970))"
                      ],
                      with: ["token": CryptoCandleConstants.apiKey])
        return request(url: url, expecting: CryptoCandle.self)
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
