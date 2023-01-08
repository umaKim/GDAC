//
//  PostContent.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/09.
//

import Foundation

struct PostContent: Codable, Hashable {
    let id: String
    let title: String
    let date: Date
    let body: String
}
