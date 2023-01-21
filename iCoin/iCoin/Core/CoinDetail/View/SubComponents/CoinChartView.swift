//
//  CoinChartView.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/17.
//

import Combine
import SwiftUI
import UIKit

class CoinChartViewData: ObservableObject {
    @Published var data = [Double]()
}

enum CoinChartViewAction {
    case selectedDays(String)
}

final class CoinChartView: BaseView {
    private var chartData = CoinChartViewData()
    private lazy var segmentedControl: UISegmentedControl = {
       let control = UISegmentedControl(items: listOfDays)
        control.selectedSegmentIndex = 0
       return control
     }()
    private let listOfDays = ["1", "7", "14", "30", "365"]
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<CoinChartViewAction, Never>()
    
    init() {
        super.init(frame: .zero)
        bind()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with data: [Double] ) {
        chartData.data = data
    }
}

// MARK: - Bind
extension CoinChartView {
    private func bind() {
        segmentedControl
            .selectedSegmentIndexPublisher
            .sink {[weak self] index in
                if index <= -1 { return }
                guard let self = self else { return }
                self.actionSubject.send(.selectedDays(self.listOfDays[index]))
            }
            .store(in: &cancellables)
    }
}

// MARK: - Set up UI
extension CoinChartView {
    private func setupLayout() {
        let chartView = ChartView()
        let chartViewControllerView = UIHostingController(rootView: chartView.environmentObject(chartData)).view!
        addSubviews(chartViewControllerView, segmentedControl)
        NSLayoutConstraint.activate([
            chartViewControllerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            chartViewControllerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            chartViewControllerView.topAnchor.constraint(equalTo: topAnchor),
            
            segmentedControl.topAnchor.constraint(equalTo: chartViewControllerView.bottomAnchor, constant: 8),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            segmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
    }
}
