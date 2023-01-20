//
//  CoinCapDetail.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/18.
//

import Foundation

struct CoinCapDetail: Codable {
    let id: String
    let symbol: String
    let name: String
    let description: CoinCapDetailDescription
    let image: CoinCapDetailImage
    let market_data: MarketData
    
}

struct CoinCapDetailDescription: Codable {
    let en: String
}

struct CoinCapDetailImage: Codable {
    let thumb: String
    let small: String
    let large: String
}

struct MarketData: Codable {
    let price_change_24h: Double
    let price_change_percentage_24h: Double
    let price_change_percentage_7d: Double
    let price_change_percentage_14d: Double
    let price_change_percentage_30d: Double
    let price_change_percentage_60d: Double
    let price_change_percentage_200d: Double
    let price_change_percentage_1y: Double
    let market_cap_change_24h: Double
    let market_cap_change_percentage_24h: Double
}
