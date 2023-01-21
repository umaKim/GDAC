//
//  NewsStory.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/22.
//

import Foundation

/// Represent news story
struct NewsStory: Codable {
    let category: String
    let datetime: TimeInterval
    let headline: String
    let image: String
    let related: String
    let source: String
    let summary: String
    let url: String
}
