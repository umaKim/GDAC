//
//  CoinDetailView.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/17.
//

import Combine
import UIKit

enum CoinDetailViewAction {
    case backButton
    case favoriteButton
//    case selectedDays(String)
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
    
    private lazy var coinLabel = CoinLabel()
    private lazy var priceLabel = CoinPriceLabel()
    
    private let chartButton: MenuBarButton = MenuBarButton(title: "Chart", font: 14)
    private let orderBook: MenuBarButton = MenuBarButton(title: "OrderBook", font: 14)
    private let metaButton: MenuBarButton = MenuBarButton(title: "About", font: 14)
    
    private(set) lazy var menuBar = MenuBarView2(buttons: [chartButton, orderBook, metaButton])
    private(set) lazy var collectionView = CellableCollectionView()
    
    init() {
        super.init(frame: .zero)
        bind()
        setupUI()
    }
    
    private func bind() {
        chartButton
            .tapPublisher
            .sink {[weak self] _ in
                self?.scroll(to: .myList)
            }
            .store(in: &cancellables)
        
        orderBook
            .tapPublisher
            .sink { _ in
                self.scroll(to: .orderBook)
            }
            .store(in: &cancellables)
        
        metaButton
            .tapPublisher
            .sink {[weak self] _ in
                self?.scroll(to: .opinions)
            }
            .store(in: &cancellables)
    }
    
    private func scroll(to item: MenuTabBarButtonType) {
        let indexPath = IndexPath(item: item.rawValue, section: 0)
        self.collectionView.scrollToItem(
            at: indexPath,
            at: [],
            animated: true
        )
    }
    
    func update(_ coinLabelData: CoinLabelData) {
        self.coinLabel.configure(with: coinLabelData)
    }
    
    func update(_ priceData: CoinPriceLabelData) {
        self.priceLabel.configure(with: priceData)
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
        backgroundColor = .systemBackground
        collectionView.isScrollEnabled = false
        
        let vStack = UIStackView(arrangedSubviews: [coinLabel, priceLabel])
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.distribution = .fill
        
        addSubviews(
            vStack,
            menuBar,
            collectionView
        )
        
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            vStack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            
            menuBar.topAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 8),
            menuBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            menuBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            menuBar.heightAnchor.constraint(equalToConstant: 50),
            
            collectionView.topAnchor.constraint(equalTo: menuBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(
                equalToSystemSpacingAfter: leadingAnchor,
                multiplier: 0
            ),
            trailingAnchor.constraint(
                equalToSystemSpacingAfter: collectionView.trailingAnchor,
                multiplier: 0
            ),
            safeAreaLayoutGuide.bottomAnchor.constraint(
                equalToSystemSpacingBelow: collectionView.bottomAnchor,
                multiplier: 0
            )
        ])
    }
}
