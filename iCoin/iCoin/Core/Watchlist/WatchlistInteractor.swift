//
//  WatchlistInteractor.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import Combine
import ModernRIBs
import Foundation

protocol WatchlistRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol WatchlistPresentable: Presentable {
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    
    var listener: WatchlistPresentableListener? { get set }
    
    func reloadData()
    func setTableEdittingMode()
}

protocol WatchlistListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol WatchlistInteractorDependency {
    var watchlistRepository: WatchlistRepository { get }
}

final class WatchlistInteractor: PresentableInteractor<WatchlistPresentable>, WatchlistInteractable  {
    
    weak var router: WatchlistRouting?
    weak var listener: WatchlistListener?
    
    //MARK: - Model
    private var watchlistChartMap: [String: [CandleStick]] = [:]
    private var watchlistQuoteMap: [String: Quote] = [:]
    private(set) var watchlistItemModels: [WatchlistItemModel] = []
    
    private let symbols: [String] = [
        "BTC",
        "ETH"
    ]
    
    private let dependency: WatchlistInteractorDependency
    
    private var cancellables: Set<AnyCancellable>
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor
    init(
        presenter: WatchlistPresentable,
        dependency: WatchlistInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
        presenter.reloadData()
        presenter.setTableEdittingMode()
        
        fetchFromNetwork(symbols: symbols)
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func fetchFromNetwork(symbols: [String]) {
        dependency
            .watchlistRepository
            .fetch(symbols: symbols)
            .sink { [weak self] datum in
                self?.myWatchlistItemMapper(receivedDatum: datum)
            }
            .store(in: &cancellables)
    }
    
    private func myWatchlistItemMapper(receivedDatum: [Datum]) {
        receivedDatum.forEach { data in
            if watchlistItemModels.contains(where: { "\($0.symbol)" == data.s }) {
                for (index, model) in self.watchlistItemModels.enumerated() {
                    if "BINANCE:\(model.symbol.uppercased())USDT" == data.s {
                        self.watchlistItemModels[index].price = "\(data.p)"
                    }
                }
            } else {
                watchlistItemModels.append(.init(symbol: data.s,
                                                 companyName: data.s,
                                                 price: "\(data.p)",
                                                 changeColor: .red,
                                                 changePercentage: "0.5"))
            }
        }
        
        self.presenter.reloadData()
    }
}

extension WatchlistInteractor: WatchlistPresentableListener {
    func removeItem(at indexPath: IndexPath) {
        //Delete Item from Persistance
        //Delete Item from model (watchlistItemModels)
    }
    
    func didTap(indexPath: IndexPath) {
        
    }
    
    func updateSections(completion: ([WatchlistItemModel]) -> Void) {
        completion(watchlistItemModels)
    }
}
