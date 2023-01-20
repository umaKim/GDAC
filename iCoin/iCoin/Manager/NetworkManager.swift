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

protocol WatchlistNetworkable {
    func fetchCryptoCandle(of symbol: String) -> AnyPublisher<CryptoCandle, Error>
}

protocol NewsNetWorkable {
    func fetchNews(of symbol: String) -> AnyPublisher<NewsDataResponse, Error>
}

protocol CoinCapAssetNetworkable {
    func fetchCoinCapAssets() -> AnyPublisher<CoinCapAssetResponse, Error>
}

protocol CoinCapMetaNetworkable {
    func fetchMetaData(of symbol: String) -> AnyPublisher<CoinCapDetail, Error>
}

protocol CoinChartDataNetworkable {
    func fetchCoinChart(of id: String, days: String) -> AnyPublisher<CoinChartData, Error>
}

final class NetworkManager: WatchlistNetworkable, NewsNetWorkable, CoinCapAssetNetworkable, CoinCapMetaNetworkable, UrlConfigurable {
    
    private enum NewsConstants {
        static let apiKey = "508858945962b1d801891796a6d67f8076873f9996b13b48e5eb63030be21ec4"
        static let newsBaseUrl = "https://min-api.cryptocompare.com/data/v2/news/"
    }
    
    private enum CryptoCandleConstants {
        static let url = "/crypto/candle"
    }
    
    private enum SymbolConstants {
        static let url = "/crypto/symbol"
    }
    
    private enum FinnHubApi {
        static let apiKey = "c3c6me2ad3iefuuilms0"
        static let baseUrl = "https://finnhub.io/api/v1"
        static let day: TimeInterval = 3600 * 24
    }
    
    private enum CoinCapApi {
        static let baseUrl = "https://api.coincap.io/v2/assets/"
    }
    
    private enum CoinGeckoApi {
        static let baseUrl = "https://api.coingecko.com/api/v3/coins/"
    }
    
    ///Perform list of Assets registered on CoinCap
    ///Return AnyPublisher cointaining CoinCapAssetResponse with Error
    func fetchCoinCapAssets() -> AnyPublisher<CoinCapAssetResponse, Error> {
        let url = url(for: CoinCapApi.baseUrl, with: ["limit": "100"])
        return request(url: url, expecting: CoinCapAssetResponse.self)
    }
    
    func fetchMetaData(of symbol: String) -> AnyPublisher<CoinCapDetail, Error> {
        let url = url(
            for: "https://api.coingecko.com/api/v3/coins/" + symbol,
            queryParams: [
                "localization": "false",
                "tickers" : "false",
                "market_data" : "true",
                "community_data" : "true",
                "developer_data": "false",
                "sparkline": "false"
            ]
        )
        return request(url: url, expecting: CoinCapDetail.self)
    }
    
    ///Perform News api call
    ///return AnyPublisher containing NewsDataResponse
    func fetchNews(of symbol: String = "") -> AnyPublisher<NewsDataResponse, Error> {
        let url = url(
            for: NewsConstants.newsBaseUrl,
            with: [
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
        
        let url = url(
            for: FinnHubApi.baseUrl + CryptoCandleConstants.url,
            queryParams: [
                "symbol": "BINANCE:BTCUSDT",
                "resolution": "D",
                "from": "\(Int(today.timeIntervalSince1970))",
                "to": "\(Int(prior.timeIntervalSince1970))"
            ],
            with: ["token": FinnHubApi.apiKey]
        )
        return request(url: url, expecting: CryptoCandle.self)
    }
    
    /// API Errors
    private enum APIError: Error {
        case noDataReturned
        case invalidUrl
    }
}

extension NetworkManager: CoinChartDataNetworkable {
    func fetchCoinChart(of id: String, days: String) -> AnyPublisher<CoinChartData, Error> {
        let url = url(
            for: CoinGeckoApi.baseUrl + id + "/market_chart",
            queryParams: [
                "vs_currency": "usd",
                "days" : "1"
            ]
        )
        return request(url: url, expecting: CoinChartData.self)
    }
}

// MARK: - General Request
extension NetworkManager {
    /// Perform api call
    /// - Parameters:
    ///   - url: URL to hit
    ///   - expecting: Type we expect to decode data to
    ///   - completion: Result callback
    private func request<T: Codable>(url: URL?, expecting: T.Type) -> AnyPublisher<T, Error> {
        Future { promise in
            guard let url = url else { return
                promise(.failure(APIError.invalidUrl))}
            
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
