//
//  CandleStickChartView.swift
//  iCoin
//
//  Created by 김윤석 on 2023/06/01.
//

import UIKit
import LightweightCharts

final class ChartView: UIView {
    private var chart: LightweightCharts?
    private var candleStickSeries: CandlestickSeries?
    private var volumeSeries: HistogramSeries?
    init() {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        setupChart()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - Public Method
extension ChartView {
    func updateData(with data: ChartData) {
        var candleStickDatum: [CandlestickData] = []
        var volumeDatum: [HistogramData] = []
        for index in 0..<data.openPrice.count {
            //CandleStick Data update
            candleStickDatum.append(.init(
                time: .utc(timestamp: data.time[index]),
                open: data.openPrice[index],
                high: data.highPrice[index],
                low: data.lowPrice[index],
                close: data.closePrice[index]
            ))
            //Volume Data update
            volumeDatum.append(.init(
                color: data.openPrice[index] > data.closePrice[index] ? .init(UIColor.systemRed.withAlphaComponent(0.5)) : .init(UIColor.systemGreen.withAlphaComponent(0.5)),
                time: .utc(timestamp: data.time[index]),
                value: data.volume[index]
            ))
        }
        candleStickSeries?.setData(data: candleStickDatum)
        volumeSeries?.setData(data: volumeDatum)
    }
}
//MARK: - Set up UI
extension ChartView {
    private func setupChart() {
        let options = ChartOptions(
            layout: LayoutOptions(
                backgroundColor: .init(UIColor.systemBackground),
                textColor: .init(UIColor.label)
            ),
            rightPriceScale: VisiblePriceScaleOptions(borderColor: "rgba(197, 203, 206, 0.8)"),
            timeScale: TimeScaleOptions(borderColor: "rgba(197, 203, 206, 0.8)"),
            crosshair: CrosshairOptions(mode: .normal),
            grid: GridOptions(
                verticalLines: GridLineOptions(color: "rgba(197, 203, 206, 0.5)"),
                horizontalLines: GridLineOptions(color: "rgba(197, 203, 206, 0.5)")
            )
        )
        chart = LightweightCharts(options: options)
        guard let chart else { return }
        addSubviews(chart)
        NSLayoutConstraint.activate([
            chart.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            chart.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            chart.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            chart.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        setupChartStyle()
    }
    
    private func setupChartStyle() {
        // CandleStick Chart Setting
        let candleStickOptions = CandlestickSeriesOptions(
            upColor: .init(UIColor.systemGreen),
            downColor: .init(UIColor.systemRed),
            borderUpColor: .init(UIColor.systemGreen),
            borderDownColor: .init(UIColor.systemRed),
            wickUpColor:.init(UIColor.systemGreen),
            wickDownColor: .init(UIColor.systemRed)
        )
        candleStickSeries = chart?.addCandlestickSeries(options: candleStickOptions)
        // Volume Chart Setting
        let volumeSeriesOptions = HistogramSeriesOptions(
            priceScaleId: "123",
            priceLineVisible: false,
            priceFormat: .builtIn(
                BuiltInPriceFormat(
                    type: .volume,
                    precision: nil,
                    minMove: nil
                )
            ),
            color: "rgba(76, 175, 80, 0.5)"
        )
        volumeSeries = chart?.addHistogramSeries(options: volumeSeriesOptions)
        volumeSeries?.priceScale().applyOptions(
            options: PriceScaleOptions(
                scaleMargins: PriceScaleMargins(
                    top: 0.85,
                    bottom: 0
                )
            )
        )
    }
}
