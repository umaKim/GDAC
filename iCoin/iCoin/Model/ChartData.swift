//
//  ChartData.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/20.
//

import Foundation

struct ChartData: Codable {
    let c: [Double] // close price
    let h: [Double] // high price
    let l: [Double] // low price
    let o: [Double] // open price
    let t: [Double] // timestamp price
    let v: [Double] // volume data
}
