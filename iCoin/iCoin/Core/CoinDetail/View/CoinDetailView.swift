//
//  CoinDetailView.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/17.
//
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
        addSubviews(contentScrollView)
        contentScrollView.addSubviews(contentView)
        
        backButton.tintColor = .gdacBlue
        favoriteButton.tintColor = .gdacBlue
        
        backgroundColor = .systemBackground
        
        contentView.addSubviews(
            coinLabel,
            priceLabel,
            chartView,
            metaView
        )
        
        NSLayoutConstraint.activate([
            contentScrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor),
            
            coinLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            coinLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            priceLabel.topAnchor.constraint(equalTo: coinLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            chartView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            chartView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            metaView.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 8),
            metaView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            metaView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            metaView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
