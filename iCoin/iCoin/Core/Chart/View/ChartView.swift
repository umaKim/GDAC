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
        backgroundColor = .systemBackground
        setupUI()
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
            
            if let openPrice = data.openPrice.last,
               let closingPrice = data.closePrice.last {
                self.candleStickChartView.zoomToCenter(scaleX: 80, scaleY: 20)
                self.candleStickChartView.moveViewTo(
                    xValue: Double(data.volume.count - 1),
                    yValue: (openPrice + closingPrice) / 2,
                    axis: .right
                )
            }
            let dateFormatter = self.generateDateFormatter(by: .twentyFourHours)
            self.candleStickChartView.xAxis.valueFormatter = IndexAxisValueFormatter(
                values: data.time.map({ dateFormatter.string(from: Date(timeIntervalSince1970: $0)) })
            )
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
            
            if let volume = data.volume.last {
                self.barChartView.zoomToCenter(scaleX: 80, scaleY: 20)
                self.barChartView.moveViewTo(
                    xValue: Double(data.volume.count - 1),
                    yValue: volume,
                    axis: .right
                )
            }
            
            let dateFormatter = self.generateDateFormatter(by: .twentyFourHours)
            self.barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(
                values: data.time.map({ dateFormatter.string(from: Date(timeIntervalSince1970: $0)) })
            )
        }
    }
    
    private func generateDateFormatter(by chartInterval: ChartInterval) -> DateFormatter {
        let dateFormatter = DateFormatter()
        switch chartInterval {
        case .oneMinute:
            dateFormatter.dateFormat = "dd-HH:mm"
        case .tenMinutes:
            dateFormatter.dateFormat = "dd-HH:mm"
        case .thirtyMinutes:
            dateFormatter.dateFormat = "dd-HH:mm"
        case .oneHour:
            dateFormatter.dateFormat = "dd-HH:mm"
        case .twentyFourHours:
            dateFormatter.dateFormat = "yyyy-MM-dd"
        default:
            dateFormatter.dateFormat = "dd-HH:mm"
        }
        
        return dateFormatter
    }
    
    enum ChartInterval: String {
        case oneMinute = "1m"
        case threeMinutes = "3m"
        case fiveMinutes = "5m"
        case tenMinutes = "10m"
        case thirtyMinutes = "30m"
        case oneHour = "1h"
        case sixHours = "6h"
        case twelveHours = "12h"
        case twentyFourHours = "24h"
        
        var pathValue: String {
            return self.rawValue
        }
        
        init?(interval: String?) {
            switch interval {
            case "1분":
                self = .oneMinute
            case "10분":
                self = .tenMinutes
            case "30분":
                self = .thirtyMinutes
            case "1시간":
                self = .oneHour
            case "일":
                self = .twentyFourHours
            default:
                return nil
            }
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
