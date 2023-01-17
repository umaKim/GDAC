//
//  SearchRepository.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/16.
//
import Combine
import Foundation

protocol SearchRepository {
    func fetchSymbols() -> AnyPublisher<[SymbolResult], Error>
}

struct SearchRepositoryImp: SearchRepository {
    private let network: SymbolsNetworkable
    
    init(network: SymbolsNetworkable) {
        self.network = network
    }
    
    func fetchSymbols() -> AnyPublisher<[SymbolResult], Error> {
        network.fetchSymbols()
    }
}
