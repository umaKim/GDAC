//
//  Quote.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/06.
//

import Foundation

struct Quote: Codable {
    let currentPrice: Double?
    let changePrice: Double?
    let percentChange: Double?
    
    let highPriceOfTheDay: Double?
    let lowPriceOfTheDay: Double?
    let openPriceOfTheDay: Double?
    let previousClosePrice: Double?
    
    enum CodingKeys: String, CodingKey {
        case currentPrice = "c"
        case changePrice = "d"
        case percentChange = "dp"
        case highPriceOfTheDay = "h"
        case lowPriceOfTheDay = "l"
        case openPriceOfTheDay = "o"
        case previousClosePrice = "pc"
    }
}
