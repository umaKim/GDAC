//
//  WatchlistRepository.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/07.
//
import Combine
import Foundation

protocol WebsocketRepository {
    func fetch(symbols: [String]) -> AnyPublisher<[Datum], Never>
    func fetchCryptoCandle(of symbol: String) -> AnyPublisher<CryptoCandle, Error>
    func disconnect()
    func connect()
}

final class WebsocketRepositoryImp: WebsocketRepository {
   
    private let websocket: WebSocketProtocol
    private let network: WatchlistNetworkable
    
    private var cancellables: Set<AnyCancellable>
    
    init(
        websocket: WebSocketProtocol,
        network: WatchlistNetworkable
    ) {
        self.websocket = websocket
        self.network = network
        self.cancellables = .init()
    }
    
    func fetch(symbols: [String]) -> AnyPublisher<[Datum], Never> {
//        websocket.resume()
        websocket.webSocket(symbols: symbols)
//        websocket.receiveMessage()
        
        return websocket
            .dataPublisher
            .eraseToAnyPublisher()
    }
    
    func disconnect() {
        websocket.disconnect()
    }
    
    func connect() {
        websocket.connect()
    }
    
    func fetchCryptoCandle(of symbol: String) -> AnyPublisher<CryptoCandle, Error> {
        return network.fetchCryptoCandle(of: symbol).eraseToAnyPublisher()
    }
}
