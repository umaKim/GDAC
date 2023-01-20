//
//  WatchlistRepository.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/16.
//

import Combine
import Foundation

protocol WatchlistRepository {
    // MARK: - Socket
    func fetch(symbols: [String]) -> AnyPublisher<[Datum], Never>
    func disconnect()
    func connect()
    
    // MARK: - Network for fetching Asset list
    func fetchSymbols() -> AnyPublisher<CoinCapAssetResponse, Error>
}

struct WatchlistRepositoryImp: WatchlistRepository {
    private let websocket: WebSocketProtocol
    private let network: CoinCapAssetNetworkable
    
    init(
        websocket: WebSocketProtocol,
        network: CoinCapAssetNetworkable
    ) {
        self.websocket = websocket
        self.network = network
    }
    
    func fetch(symbols: [String]) -> AnyPublisher<[Datum], Never> {
        websocket.set(symbols: symbols)
        
        return websocket
            .dataPublisher
            .eraseToAnyPublisher()
    }
    
    func connect() {
        websocket.connect()
    }
    
    func disconnect() {
        websocket.disconnect()
    }
    
    func fetchSymbols() -> AnyPublisher<CoinCapAssetResponse, Error> {
        network.fetchCoinCapAssets()
    }
}

struct PortfolioWatchlistRepositoryImp: WatchlistRepository {
    
    private let websocket: WebSocketProtocol
    private let persistance: PersistanceService
    
    init(
        websocket: WebSocketProtocol,
        persistance: PersistanceService
    ) {
        self.websocket = websocket
        self.persistance = persistance
    }
    
    func fetch(symbols: [String]) -> AnyPublisher<[Datum], Never> {
        websocket.set(symbols: symbols)
        
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
    
    func fetchSymbols() -> AnyPublisher<CoinCapAssetResponse, Error> {
        Future<CoinCapAssetResponse, Error> { promise in
            promise(.success(CoinCapAssetResponse(data: self.persistance.watchlist)))
        }
        .eraseToAnyPublisher()
    }
    
}
