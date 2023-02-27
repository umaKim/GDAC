//
//  OrderBookResponse.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/27.
//

import Foundation

struct OrderBookResponse: Decodable {
    let status: String
    let data: OrderBookData
}

struct OrderBookData: Decodable {
    let bids: [OrderBook]
    let asks: [OrderBook]
}

struct OrderBook: Decodable, Hashable {
    let price: String
    let quantity: String
}
