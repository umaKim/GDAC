//
//  PortfolioRepository.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/17.
//
import Combine
import Foundation

protocol PortfolioRepository {
    func fetchSymbols() -> AnyPublisher<[CoinCapAsset], Error>
}

struct PortfolioRepositoryImp: PortfolioRepository {
    private let persistence: PersistanceService
    
    init(persistence: PersistanceService) {
        self.persistence = persistence
    }
    
    private let subject = PassthroughSubject<[CoinCapAsset], Error>()
    
    func fetchSymbols() -> AnyPublisher<[CoinCapAsset], Error> {
        Future<[CoinCapAsset], Error> { promise in
            promise(.success(self.persistence.watchlist))
        }
        .eraseToAnyPublisher()
    }
}
