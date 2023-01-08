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
    }
}

