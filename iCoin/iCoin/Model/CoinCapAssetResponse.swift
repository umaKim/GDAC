//
//  CoinCapAssetResponse.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/18.
//

import Foundation

struct CoinCapAssetResponse: Codable {
    let data: [CoinCapAsset]
}

struct CoinCapAsset: Codable, Hashable {
    let id: String
    let rank: String
    let symbol: String
    let name: String
    let priceUsd: String
    let changePercent24Hr: String
}
