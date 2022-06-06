//
//  WatchlistItemModel.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/06.
//
import UIKit

struct WatchlistItemModel: Hashable {
    let symbol: String
    let companyName: String
    let price: String // formatted
    let changeColor: UIColor // red or green
    let changePercentage: String // formatted
//    let chartViewModel: StockChartModel //StockChartView.ViewModel
}
