//
//  WatchlistRepository.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/07.
//
import Combine
import Foundation

protocol WatchlistRepository {
    func fetch(symbols: [String]) -> AnyPublisher<[Datum], Never>
    func fetchCryptoCandle(of symbol: String) -> AnyPublisher<CryptoCandle, Error>
    func stopFetch()
    func resume()
}

final class WatchlistRepositoryImp: WatchlistRepository {
    func fetchCryptoCandle(of symbol: String) -> AnyPublisher<CryptoCandle, Error> {
        return network.fetchCryptoCandle(of: symbol).eraseToAnyPublisher()
    }
    
    private let websocket: WebSocketProtocol
    private let network: NetworkProtocol
    
    private var cancellables: Set<AnyCancellable>
    
    init(
        websocket: WebSocketProtocol,
        network: NetworkProtocol
    ) {
        self.websocket = websocket
        self.network = network
        self.cancellables = .init()
    }
    
    func fetch(symbols: [String]) -> AnyPublisher<[Datum], Never> {
        websocket.webSocket(symbols: symbols)
        websocket.receiveMessage()
        
        return websocket
            .dataPublisher
            .eraseToAnyPublisher()
    }
    
    func stopFetch() {
        websocket.disconnect()
    }
    
    func resume() {
        websocket.resume()
    }
}
