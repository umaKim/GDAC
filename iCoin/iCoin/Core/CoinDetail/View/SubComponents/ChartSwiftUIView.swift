//
//  SwiftUIView.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/13.
//

import StockCharts
import SwiftUI

struct ChartView: View {
    @EnvironmentObject var chartData: CoinChartViewData
    
    var body: some View {
        LineChartView(lineChartController: LineChartController(prices: chartData.data))
    }
}
