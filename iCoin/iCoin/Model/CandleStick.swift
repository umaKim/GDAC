//
//  CandleStick.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/06.
//

import Foundation

/// Model to represent data for single day
struct CandleStick {
    let date: Date
    let high: Double
    let low: Double
    let open: Double
    let close: Double
}

