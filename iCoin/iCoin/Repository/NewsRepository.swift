//
//  NewsRepository.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/07.
//

import Combine

protocol NewsRepository {
    func fetchNews(of symbol: String) -> AnyPublisher<NewsDataResponse, Error>
}

struct NewsRepositoryImp: NewsRepository {
    
    private let network: NewsNetWorkable
    
    init(network: NewsNetWorkable) {
        self.network = network
    }
    
    func fetchNews(of symbol: String) -> AnyPublisher<NewsDataResponse, Error> {
        network.fetchNews(of: symbol)
    }
}
