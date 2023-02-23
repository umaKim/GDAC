//
//  CoinDetailViewController.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/07.
//
import Combine
import ModernRIBs
import UIKit
import SwiftUI

protocol CoinDetailPresentableListener: AnyObject {
    func didTapBackButton()
    func didTapFavoriteButton()
}

final class CoinDetailViewController: UIViewController, CoinDetailPresentable, CoinDetailViewControllable {
    
    weak var listener: CoinDetailPresentableListener?
    private var cellableDataSource = CellableViewControllerDatasource()
    private let contentView = CoinDetailView()
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
        cellableDataSource.view = view
        contentView.collectionView.dataSource = cellableDataSource
        contentView.collectionView.delegate = cellableDataSource
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItems = [contentView.backButton]
        navigationItem.rightBarButtonItems = [contentView.favoriteButton]
        
        bind()
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else { return }
                switch action {
                case .backButton:
                    self.listener?.didTapBackButton()
                case .favoriteButton:
                    self.listener?.didTapFavoriteButton()
//                case .selectedDays(let days):
//                    self.listener?.selectedDays(days)
                }
            }
            .store(in: &cancellables)
        
        cellableDataSource
            .contentsOffsetPublisher
            .sink {[weak self] contentsOffset in
                self?.contentView
                    .menuBar
                    .scrollIndicator(to: contentsOffset)
            }
            .store(in: &cancellables)
    }
    
    func update(symbol: CoinCapAsset) {
        navigationItem.title = symbol.name
    }
    
    func update(_ coinLabelData: CoinLabelData) {
        contentView.update(coinLabelData)
    }
    
    func update(_ coinPriceData: CoinPriceLabelData) {
        contentView.update(coinPriceData)
    }
    
    func doesSymbolInPersistance(_ exist: Bool) {
        contentView.doesSymbolInPersistance(exist)
    }
}

extension CoinDetailViewController {
    func setChart(_ view: ModernRIBs.ViewControllable) {
        cellableDataSource.appendCellableView(view)
    }
    
    func setMeta(_ view: ModernRIBs.ViewControllable) {
        cellableDataSource.appendCellableView(view)
    }
}
