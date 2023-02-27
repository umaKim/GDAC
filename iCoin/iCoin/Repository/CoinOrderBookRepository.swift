//
//  CoinOrderBookRepository.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/24.
//
import Combine
import Foundation

protocol CoinOrderBookRepository {
    func fetchOrderBook(of symbol: String) -> AnyPublisher<OrderBookResponse, Error>
}

final class CoinOrderBookRepositoryImp: CoinOrderBookRepository {
    private let network: CoinOrderBookNetworkable
    
    init(network: CoinOrderBookNetworkable) {
        self.network = network
    }
    
    func fetchOrderBook(of symbol: String) -> AnyPublisher<OrderBookResponse, Error> {
        return network.fetchOrderBook(of: symbol)
    }
}
