//
//  CoinChartRepository.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/23.
//

import Combine
import Foundation

protocol CoinChartRepository {
    func fetchChartData(of id: String) -> AnyPublisher<ChartData, Error>
}

struct CoinChartRepositoryImp: CoinChartRepository {
    private let network: CoinChartDataNetworkable
    init(network: CoinChartDataNetworkable) {
        self.network = network
    }
    
    func fetchChartData(of id: String) -> AnyPublisher<ChartData, Error> {
        network.fetchCoinChartData(of: id)
    }
}
