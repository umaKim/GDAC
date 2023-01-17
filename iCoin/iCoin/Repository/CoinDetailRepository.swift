//
//  CoinDetailRepository.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/16.
//

import Foundation

protocol CoinDetailRepository {
    func contains(_ symbol: SymbolResult) -> Bool
    func save(_ symbol: SymbolResult)
    func remove(_ symbol: SymbolResult)
}

struct CoinDetailRepositoryImp: CoinDetailRepository {
    
    private let persistance: PersistanceService
    
    init(_ persistance: PersistanceService) {
        self.persistance = persistance
    }
    
    func contains(_ symbol: SymbolResult) -> Bool {
        persistance.watchlistContains(symbol: symbol)
    }
    
    func save(_ symbol: SymbolResult) {
        persistance.addToWatchlist(symbol: symbol)
    }
    
    func remove(_ symbol: SymbolResult) {
        persistance.removeFromWatchlist(symbol: symbol)
    }
}
