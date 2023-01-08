//
//  MyWatchListInteractor.swift
//  iCoin
//
//  Created by 김윤석 on 2022/11/20.
//

import Combine
import UIKit
import ModernRIBs

protocol MyWatchListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func attachCoinDetail()
    func detachCoinDetail()
}

protocol MyWatchListPresentable: Presentable {
    var listener: MyWatchListPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func reloadData(with data: [WatchlistItemModel], animation: UITableView.RowAnimation)
    func isDataEmpty(_ isEmpty: Bool)
}

protocol MyWatchListListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol MyWatchListInteractorDependency {
    var watchlistRepository: WebsocketRepository { get }
    var persistanceRepository: PersistanceRepository { get }
}

final class MyWatchListInteractor: PresentableInteractor<MyWatchListPresentable>, MyWatchListInteractable, MyWatchListPresentableListener {
    
    weak var router: MyWatchListRouting?
    weak var listener: MyWatchListListener?
    
    //MARK: - Model
    private(set) var watchlistItemModels: [WatchlistItemModel] = []
    
    typealias Symbol = String
    
    //TODO: This should be fetched from Persistance
    private var symbols: [Symbol] = [
    ]
    
    private let dependency: MyWatchListInteractorDependency
    
    private var cancellables: Set<AnyCancellable>

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: MyWatchListPresentable,
        dependency: MyWatchListInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self

    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
        fetchMyWatchList()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
        print("MyWatchListInteractor willResignActive")
    }
    
    func viewDidAppear() {
        connectWebSocket()
    }
    
    func viewDidDisappear() {
        disconnectWebSocket()
    }
    
    func didTap() {
        router?.attachCoinDetail()
    }
    
    func coinDetailDidTapBackButton() {
        router?.detachCoinDetail()
    }
    
    private func myWatchlistItemMapper(receivedDatum: [Datum]) {
        receivedDatum.forEach {[weak self] data in
            guard let self = self else { return }
            //if watchlistItemModels already has the Symbol
            if watchlistItemModels.contains(where: {
                $0.companyName.uppercased() == data.s
            }) {
                for (index, model) in self.watchlistItemModels.enumerated() {
                    if model.companyName.uppercased() == data.s {
                        self.watchlistItemModels[index].price = "$\(data.p)"
                    }
                }
            } else {
            // if WatchlistItemModels are empty
                self.symbols.forEach {[weak self] symbol in
                    if "BINANCE:\(symbol.uppercased())USDT" == data.s {
                        self?.watchlistItemModels.append(.init(
                            symbol: symbol,
                            companyName: data.s,
                            price: "$\(data.p)",
                            changeColor: .clear,
                            changePercentage: ""
                        ))
                    }
                }
            }
        }
        presenter.reloadData(
            with: watchlistItemModels,
            animation: .none
        )
    }
}

// MARK: - Websocket Repository
extension MyWatchListInteractor {
    private func fetchFromNetwork(symbols: [String]) {
        dependency.watchlistRepository.fetch(symbols: symbols)
            .receive(on: RunLoop.main)
            .sink(receiveValue: myWatchlistItemMapper)
            .store(in: &cancellables)
    }
    
    private func connectWebSocket() {
        dependency.watchlistRepository.connect()
        fetchFromNetwork(symbols: symbols)
    }
    
    private func disconnectWebSocket() {
        dependency.watchlistRepository.disconnect()
    }
}

// MARK: - Persistance Repository
extension MyWatchListInteractor {
    private func fetchMyWatchList() {
        let savedSymbols = dependency.persistanceRepository.fetch()
        symbols = savedSymbols
        
        presenter.isDataEmpty(symbols.isEmpty)
    }
}
