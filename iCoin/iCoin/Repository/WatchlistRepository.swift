//
//  WatchlistRepository.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/16.
//

import Combine
import Foundation

protocol WatchlistRepository {
    func fetch(symbols: [String]) -> AnyPublisher<[Datum], Never>
    func disconnect()
    func connect()
    func fetchSymbols() -> AnyPublisher<[SymbolResult], Error>
}

struct WatchlistRepositoryImp: WatchlistRepository {
    private let websocket: WebSocketProtocol
    
    init(websocket: WebSocketProtocol) {
        self.websocket = websocket
    }
    
    func fetch(symbols: [String]) -> AnyPublisher<[Datum], Never> {
        websocket.webSocket(symbols: symbols)
        
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
    
    func fetchSymbols() -> AnyPublisher<[SymbolResult], Error> {
        Future { promise in
            promise(.success(StaticSymbols.symbols))
        }
        .eraseToAnyPublisher()
    }
    
    enum StaticSymbols {
        static let symbols: [SymbolResult] = [
            .init(description: "Binance BTCUSDT", displaySymbol: "BTC/USDT", symbol: "BTCUSDT"),
            .init(description: "Binance ETHUSDT", displaySymbol: "ETH/USDT", symbol: "ETHUSDT"),
            .init(description: "Binance BNBUSDT", displaySymbol: "BNB/USDT", symbol: "BNBUSDT"),
            .init(description: "Binance XRPUSDT", displaySymbol: "XRP/USDT", symbol: "XRPUSDT"),
            .init(description: "Binance BUSDUSDT", displaySymbol: "BUSD/USDT", symbol: "BUSDUSDT"),
            .init(description: "Binance ADAUSDT", displaySymbol: "ADA/USDT", symbol: "ADAUSDT"),
            .init(description: "Binance MATICUSDT", displaySymbol: "MATIC/USDT", symbol: "MATICUSDT"),
            .init(description: "Binance LTCUSDT", displaySymbol: "LTC/USDT", symbol: "LTCUSDT"),
            .init(description: "Binance DOTUSDT", displaySymbol: "DOT/USDT", symbol: "DOTUSDT"),
            .init(description: "Binance SOLUSDT", displaySymbol: "SOL/USDT", symbol: "SOLUSDT"),
            .init(description: "Binance TRXUSDT", displaySymbol: "TRX/USDT", symbol: "TRXUSDT"),
            .init(description: "Binance UNIUSDT", displaySymbol: "UNI/USDT", symbol: "UNIUSDT"),
            .init(description: "Binance AVAXUSDT", displaySymbol: "AVAX/USDT", symbol: "AVAXUSDT"),
            .init(description: "Binance LINKUSDT", displaySymbol: "LINK/USDT", symbol: "LINKUSDT"),
            .init(description: "Binance ATOMUSDT", displaySymbol: "ATOM/USDT", symbol: "ATOMUSDT"),
            .init(description: "Binance XMRUSDT", displaySymbol: "XMR/USDT", symbol: "XMRUSDT"),
            .init(description: "Binance ETCUSDT", displaySymbol: "ETC/USDT", symbol: "ETCUSDT"),
        ]
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
        websocket.webSocket(symbols: symbols)
        
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
    
    func fetchSymbols() -> AnyPublisher<[SymbolResult], Error> {
        Future<[SymbolResult], Error> { promise in
            promise(.success(self.persistance.watchlist))
        }
        .eraseToAnyPublisher()
    }
}
