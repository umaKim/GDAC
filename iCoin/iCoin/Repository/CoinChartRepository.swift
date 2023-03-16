//
//  CoinChartRepository.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/23.
//

import Combine
import Foundation

protocol CoinChartRepository {
    func fetchCoinChartData(
        of id: String,
        resolution: String,
        from fromDate: Int,
        to endDate: Int
    ) -> AnyPublisher<ChartData, Error>
}

struct CoinChartRepositoryImp: CoinChartRepository {
    private let network: CoinChartDataNetworkable
    init(network: CoinChartDataNetworkable) {
        self.network = network
    }
    
    func fetchCoinChartData(
        of id: String,
        resolution: String,
        from fromDate: Int,
        to endDate: Int
    ) -> AnyPublisher<ChartData, Error>  {
        network.fetchCoinChartData(of: id, resolution: resolution, from: fromDate, to: endDate)
    }
}
