//
//  SearchRepository.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/16.
//
import Combine
import Foundation

protocol SearchRepository {
    func fetchSymbols() -> AnyPublisher<CoinCapAssetResponse, Error>
}

struct SearchRepositoryImp: SearchRepository {
    private let network: CoinCapAssetNetworkable
    
    init(network: CoinCapAssetNetworkable) {
        self.network = network
    }
    
    func fetchSymbols() -> AnyPublisher<CoinCapAssetResponse, Error> {
        network.fetchCoinCapAssets()
    }
}
