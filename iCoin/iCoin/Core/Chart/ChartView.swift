//
//  ChartView.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/20.
//
import Charts
import UIKit

final class ChartView: UIView {
    
    private lazy var candleStickChartView: CandleStickChartView = CandleStickChartView()
    private lazy var barChartView: BarChartView = BarChartView()
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCandleStickChartView(with data: ChartData) {
        var chartEntries = [CandleChartDataEntry]()
        for index in data.time.indices {
            let entry = CandleChartDataEntry(
                x: Double(index),
                shadowH: data.highPrice[index] ,
                shadowL: data.lowPrice[index] ,
                open: data.openPrice[index] ,
                close: data.closePrice[index]
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
        for index in data.volume.indices {
            let entry = BarChartDataEntry(
                x: Double(index),
                y: data.volume[index]
            )
            chartEntries.append(entry)
            chartColors.append(data.openPrice[index] > data.closePrice[index] ? .systemBlue : .systemRed)
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
}

extension ChartView {
    private func setupUI() {
        backgroundColor = .systemBackground
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
