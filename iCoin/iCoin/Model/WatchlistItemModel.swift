//
//  WatchlistItemModel.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/06.
//
import UIKit

struct WatchlistItemModel: Hashable {
    let symbol: String
    let detailName: String
    var price: String // formatted
    let changePercentage: String // formatted
}
