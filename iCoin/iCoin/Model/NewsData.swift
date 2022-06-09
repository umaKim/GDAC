//
//  NewsData.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/07.
//

import Foundation

struct NewsDataResponse: Codable {
    let Data: [NewsData]
}

struct NewsData: Codable {
    let imageurl: String
    let title: String
    let url: String
    let source: String
    let body: String
    let published_on: TimeInterval
}
