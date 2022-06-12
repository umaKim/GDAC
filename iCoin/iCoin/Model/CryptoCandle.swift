//
//  CryptoCandle.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/12.
//

import Foundation

struct CryptoCandle: Codable {
      let c: [Double]?
      let h: [Double]?
      let l: [Double]?
      let o: [Double]?
      let t: [TimeInterval]?
}
