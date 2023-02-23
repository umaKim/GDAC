//
//  CoinMetaDataRepository.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/23.
//
import Combine
import Foundation

protocol CoinMetaDataRepository {
    func fetchMetaData(of symbol: String) -> AnyPublisher<CoinCapDetail, Error>
}

struct CoinMetaDataRepositoryImp: CoinMetaDataRepository {
    func fetchMetaData(of symbol: String) -> AnyPublisher<CoinCapDetail, Error> {
        network.fetchMetaData(of: symbol)
    }
    
    private let network: CoinCapMetaNetworkable
    init(network: CoinCapMetaNetworkable) {
        self.network = network
    }
}
