//
//  CoinChartView.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/17.
//

import SwiftUI
import UIKit

final class CoinChartView: UIView {
    private var chartData = CoinChartViewData()
    
    init() {
        super.init(frame: .zero)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with data: [Double] ) {
        chartData.data = data
    }
    
    private func setupLayout() {
        let chartView = ChartView()
        let chartViewControllerView = UIHostingController(rootView: chartView.environmentObject(chartData)).view!
        
        addSubviews(chartViewControllerView)
        
        NSLayoutConstraint.activate([
            chartViewControllerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chartViewControllerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chartViewControllerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            chartViewControllerView.topAnchor.constraint(equalTo: topAnchor),
            
            heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
    }
}

class CoinChartViewData: ObservableObject {
    @Published var data = [Double]()
}
