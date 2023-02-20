//
//  ChartData.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/20.
//

import Foundation

struct ChartData: Codable {
    let closePrice: [Double]    // close price
    let highPrice: [Double]     // high price
    let lowPrice: [Double]      // low price
    let openPrice: [Double]     // open price
    let time: [Double]          // timestamp price
    let volume: [Double]        // volume data
    
    enum CodingKeys: String, CodingKey {
        case closePrice = "c"
        case highPrice = "h"
        case lowPrice = "l"
        case openPrice = "o"
        case time = "t"
        case volume = "v"
    }
}
