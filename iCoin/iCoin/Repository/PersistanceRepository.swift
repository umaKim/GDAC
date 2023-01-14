//
//  PersistanceRepository.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/07.
//

import Foundation

protocol PersistanceRepository {
    func fetch() -> [SymbolResult]
    func save()
    func remove()
}

class PersistanceRepositoryImp: PersistanceRepository {
    
    private let persistance: PersistanceService
    
    init(_ persistance: PersistanceService) {
        self.persistance = persistance
    }
    
    func fetch() -> [SymbolResult] {
        persistance.watchlist
    }
    
    func save() {
    }
    
    func remove() {
        
    }
}
