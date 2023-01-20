//
//  CoinDetailMetaViewData.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/21.
//

import Foundation

struct CoinDetailMetaViewData {
    let description: String
    let metaDatum: [MetaData]
}

struct MetaData {
    let title: String
    let value: String
}
