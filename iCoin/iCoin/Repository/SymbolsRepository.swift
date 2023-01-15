//
//  SearchRepository.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/12.
//

import Combine

protocol SymbolsRepository {
    func fetchSymbols() -> AnyPublisher<[SymbolResult], Error>
}

final class SymbolsRepositoryImp: SymbolsRepository {
    
    private let network: SymbolsNetworkable
    
    init(network: SymbolsNetworkable) {
        self.network = network
    }
    
    func fetchSymbols() -> AnyPublisher<[SymbolResult], Error> {
        return network.fetchSymbols()
final class SymbolsConstantRepositoryImp: SymbolsRepository {
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
    //        .init(description: "Binance USDCUSDT", displaySymbol: "USDC/USDT", symbol: "USDCUSDT"),
            .init(description: "Binance BNBUSDT", displaySymbol: "BNB/USDT", symbol: "BNBUSDT"),
            .init(description: "Binance XRPUSDT", displaySymbol: "XRP/USDT", symbol: "XRPUSDT"),
            .init(description: "Binance BUSDUSDT", displaySymbol: "BUSD/USDT", symbol: "BUSDUSDT"),
            .init(description: "Binance ADAUSDT", displaySymbol: "ADA/USDT", symbol: "ADAUSDT"),
            .init(description: "Binance MATICUSDT", displaySymbol: "MATIC/USDT", symbol: "MATICUSDT"),
    //        .init(description: "Binance DAIUSDT", displaySymbol: "DAI/USDT", symbol: "DAIUSDT"),
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
    }
}

