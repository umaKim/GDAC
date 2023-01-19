//
//  CoinDetailRepository.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/16.
//

import Foundation

protocol CoinDetailRepository {
    func contains(_ symbol: CoinCapAsset) -> Bool
    func save(_ symbol: CoinCapAsset)
    func remove(_ symbol: CoinCapAsset)
    
}

struct CoinDetailRepositoryImp: CoinDetailRepository {
    
    private let persistance: PersistanceService
    
    init(_ persistance: PersistanceService) {
        self.persistance = persistance
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
    
    func remove(_ symbol: SymbolResult) {
        persistance.removeFromWatchlist(symbol: symbol)
    }
}
