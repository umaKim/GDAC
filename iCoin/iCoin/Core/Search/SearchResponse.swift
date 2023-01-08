//
//  SearchResponse.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/12.
//

import Foundation

/// API response for search
struct SearchResponse: Codable {
    let result: [SymbolResult]
}

/// A single search result
struct SymbolResult: Codable, Hashable {
    let description: String
    let displaySymbol: String
    let symbol: String
}
