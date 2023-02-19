//
//  CoinDetailView.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/17.
//
import Charts
import SwiftUI
import Combine
import UIKit

enum CoinDetailViewAction {
    case backButton
    case favoriteButton
    case selectedDays(String)
}

final class CoinDetailView: BaseView {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<CoinDetailViewAction, Never>()
    
    private(set) lazy var backButton = UIBarButtonItem(
        image: .init(systemName: "chevron.backward"),
        style: .done,
        target: self,
        action: #selector(backButtonDidTap)
    )
    
    private(set) lazy var favoriteButton = UIBarButtonItem(
        image: .init(systemName: ""),
        style: .done,
        target: self,
        action: #selector(favoriteButtonDidTap)
    )
    
    private var contentScrollView = UIScrollView()
    private var contentView = UIView()
    private lazy var label: UILabel = UILabel()
    
    private lazy var coinLabel = CoinLabel()
    private lazy var priceLabel = CoinPriceLabel()
    private lazy var chartView = CoinChartView()
    private lazy var metaView = CoinDetailMetaView()
    
    private lazy var candleStickChartView: CandleStickChartView = CandleStickChartView()
    private lazy var barChartView: BarChartView = BarChartView()
    
    init() {
        super.init(frame: .zero)
        bind()
        setupUI()
    }
    
    private func bind() {
        chartView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else { return }
                switch action {
                case .selectedDays(let days):
                    self.actionSubject.send(.selectedDays(days))
                }
            }
            .store(in: &cancellables)
    }
    
    func update(symbol: CoinCapAsset) {
        label.numberOfLines = 5
        label.text = "\(symbol.symbol)\n\(symbol.name)\n\(symbol.changePercent24Hr)"
    }
    
    func update(_ coinLabelData: CoinLabelData) {
        self.coinLabel.configure(with: coinLabelData)
    }
    
    func update(_ priceData: CoinPriceLabelData) {
        self.priceLabel.configure(with: priceData)
    }
    
    func update(_ coinChartData: [Double]) {
        self.chartView.configure(with: coinChartData)
    }
    
    func update(_ data: CoinDetailMetaViewData) {
        self.metaView.configure(with: data)
    }
    
    func doesSymbolInPersistance(_ exist: Bool) {
        favoriteButton.image = .init(systemName: exist ? "star.fill" : "star")
    }
    
    func updateCandleStickChartView(with data: ChartData) {
        var chartEntries = [CandleChartDataEntry]()
        for index in data.t.indices {
            let entry = CandleChartDataEntry(
                x: Double(index),
                shadowH: data.h[index] ,
                shadowL: data.l[index] ,
                open: data.o[index] ,
                close: data.c[index]
            )
            chartEntries.append(entry)
        }
        let chartDataSet = CandleChartDataSet(entries: chartEntries)
        chartDataSet.increasingColor = .systemRed
        chartDataSet.decreasingColor = .systemBlue
        chartDataSet.neutralColor = .systemRed
        chartDataSet.increasingFilled = true
        chartDataSet.shadowColorSameAsCandle = true
        chartDataSet.drawValuesEnabled = false
        let chartData = CandleChartData(dataSet: chartDataSet)
        DispatchQueue.main.async {
            self.candleStickChartView.data = chartData
            self.candleStickChartView.fitScreen()
        }
    }
    
    func updateBarChartView(with data: ChartData) {
        var chartEntries = [BarChartDataEntry]()
        var chartColors = [UIColor]()
        for index in data.v.indices {
            let entry = BarChartDataEntry(x: Double(index), y: data.v[index])
            chartEntries.append(entry)
            
            chartColors.append(data.o[index] > data.c[index] ? .systemBlue : .systemRed)
        }
        
        let chartDataSet = BarChartDataSet(entries: chartEntries)
        chartDataSet.colors = chartColors
        chartDataSet.drawValuesEnabled = false
        chartDataSet.highlightEnabled = false
        
        let chartData = BarChartData(dataSet: chartDataSet)
        DispatchQueue.main.async {
            self.barChartView.data = chartData
            self.barChartView.fitScreen()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Button Actions
extension CoinDetailView {
    @objc
    private func backButtonDidTap() {
        actionSubject.send(.backButton)
    }
    
    @objc
    private func favoriteButtonDidTap() {
        actionSubject.send(.favoriteButton)
    }
}

// MARK: - Set up UI
extension CoinDetailView {
    private func setupUI() {
        setUpCandlestickChartView()
        setUpBarChartView()
        addSubviews(candleStickChartView, barChartView)
        NSLayoutConstraint.activate([
            candleStickChartView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            candleStickChartView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            candleStickChartView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            candleStickChartView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.55),
            barChartView.topAnchor.constraint(equalTo: candleStickChartView.bottomAnchor),
            barChartView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            barChartView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            barChartView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    private func setUpCandlestickChartView() {
        candleStickChartView.xAxis.labelPosition = .bottom
        candleStickChartView.leftAxis.enabled = false
        candleStickChartView.xAxis.setLabelCount(4, force: false)
        candleStickChartView.legend.enabled = false
        candleStickChartView.pinchZoomEnabled = true
        candleStickChartView.scaleXEnabled = true
        candleStickChartView.scaleYEnabled = true
        candleStickChartView.doubleTapToZoomEnabled = false
    }
    
    private func setUpBarChartView() {
        barChartView.legend.enabled = false
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.setLabelCount(4, force: false)
        barChartView.leftAxis.enabled = false
        barChartView.pinchZoomEnabled = true
        barChartView.scaleXEnabled = true
        barChartView.scaleYEnabled = true
        barChartView.doubleTapToZoomEnabled = false
        barChartView.rightAxis.enabled = true
        barChartView.rightAxis.axisMinimum = 0
        barChartView.leftAxis.axisMinimum = 0
    }
}
