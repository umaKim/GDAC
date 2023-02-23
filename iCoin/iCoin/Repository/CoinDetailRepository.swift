//
//  CoinDetailRepository.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/16.
//
import Combine
import Foundation

protocol CoinDetailRepository {
    func contains(_ symbol: CoinCapAsset) -> Bool
    func save(_ symbol: CoinCapAsset)
    func remove(_ symbol: CoinCapAsset)
    
    func connect()
    func disconnect()
    func fetch(symbol: String)
    
    func fetchMetaData(of symbol: String) -> AnyPublisher<CoinCapDetail, Error>
}

typealias CoinDetailNetworkable = CoinChartDataNetworkable & CoinCapMetaNetworkable

struct CoinDetailRepositoryImp: CoinDetailRepository {
    private let persistance: PersistanceService
    private let websocket: WebSocketProtocol
    private let network: CoinDetailNetworkable
    
    init(
        _ persistance: PersistanceService,
        _ websocket: WebSocketProtocol,
        _ network: CoinDetailNetworkable
    ) {
        self.persistance = persistance
        self.websocket = websocket
        self.network = network
    }
}

// MARK: - Persistance
extension CoinDetailRepositoryImp {
    func contains(_ symbol: CoinCapAsset) -> Bool {
        persistance.watchlistContains(symbol: symbol)
    }
    
    func save(_ symbol: CoinCapAsset) {
        persistance.addToWatchlist(symbol: symbol)
    }
    
    func remove(_ symbol: CoinCapAsset) {
        persistance.removeFromWatchlist(symbol: symbol)
    }
}

// MARK: - Websocket
extension CoinDetailRepositoryImp {
    func connect() {
        websocket.connect()
    }
    
    func disconnect() {
        websocket.disconnect()
    }
    
    func fetch(symbol: String) {
        websocket.set(symbols: [symbol])
    }
}

// MARK: - Network
extension CoinDetailRepositoryImp {
    func fetchMetaData(of symbol: String) -> AnyPublisher<CoinCapDetail, Error> {
        network.fetchMetaData(of: symbol)
    }
}
