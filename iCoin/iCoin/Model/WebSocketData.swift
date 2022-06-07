//
//  WebSocketData.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/07.
//

import Foundation

struct WebSocketData : Decodable {
    
    let data: [Datum]
    
}

struct Datum : Decodable, Hashable  {
    
    let p: Double
    var s: String

}
