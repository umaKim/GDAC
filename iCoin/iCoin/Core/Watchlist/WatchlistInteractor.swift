//
//  WatchlistInteractor.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import Combine
import ModernRIBs
import UIKit.UITableView

protocol WatchlistRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol WatchlistPresentable: Presentable {
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    
    var listener: WatchlistPresentableListener? { get set }
    
    func reloadData(with data: [WatchlistItemModel], animation: UITableView.RowAnimation)
    func setTableEdittingMode()
}

protocol WatchlistListener: AnyObject {
    func watchlistDidTap(_ symbol: SymbolResult)
}

protocol WatchlistInteractorDependency {
    var watchlistRepository: WebsocketRepository { get }
    var symbolsRepository: SymbolsRepository { get }
    var edittingButtonDidTap: AnyPublisher<Void, Never> { get }
    var mainViewLifeCycleDidChange: AnyPublisher<MainViewLifeCycle, Never> { get }
}

final class WatchlistInteractor: PresentableInteractor<WatchlistPresentable>, WatchlistInteractable  {
    
    weak var router: WatchlistRouting?
    weak var listener: WatchlistListener?
    
    weak var mainInteractorListener: MainListener?
    
    //MARK: - Model
    private var watchlistItemModels: [WatchlistItemModel] = []
    
    //TODO: This should be fetched from Network
    private var symbols: [SymbolResult] = StaticSymbols.symbols
    
    private var displaySymbols: [Symbol] {
        self.symbols.map({$0.displaySymbol})
    }
    
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
        bind()
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    private func fetchSymbols() {
        dependency
            .symbolsRepository
            .fetchSymbols()
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: {[weak self] symbols in
                guard let self = self else { return }
                self.receivedSymbolsMapper(symbols)
                self.fetchFromNetwork(symbols: self.displaySymbols)
            }
            .store(in: &cancellables)
    }
    
    private func receivedSymbolsMapper(_ symbols: [SymbolResult]) {
        self.symbols = symbols.filter {
            $0.displaySymbol.localizedStandardContains("/USDT")
        }.map({
            var newDisplaySymbol = $0.displaySymbol
            if let dotRange = newDisplaySymbol.range(of: "/") {
                newDisplaySymbol.removeSubrange(dotRange.lowerBound..<newDisplaySymbol.endIndex)
            }
            return .init(description: $0.description, displaySymbol: newDisplaySymbol, symbol: $0.symbol)
        })
    }
    
    private func bind() {
        dependency
            .edittingButtonDidTap
            .sink {[weak self] didTap in
                self?.presenter.setTableEdittingMode()
            }
            .store(in: &cancellables)
        
        dependency
            .mainViewLifeCycleDidChange
            .sink {[weak self] cycle in
                guard let self = self else { return }
                print("mainViewLifeCycleDidChange")
                switch cycle {
                case .viewDidAppear:
                    print("mainViewLifeCycleDidChange viewDidAppear")
                    
                    if self.symbols.isEmpty {
                        self.fetchSymbols()
                    } else {
                        self.fetchFromNetwork(symbols: self.displaySymbols)
                    }
                    
                case .viewDidDisappear:
                    print("mainViewLifeCycleDidChange viewDidDisappear")
                    self.disconnectWebSocket()
                }
            }
            .store(in: &cancellables)
    }
    
    typealias Symbol = String
    
    private func fetchFromNetwork(symbols: [Symbol]) {
        self.connectWebSocket()
        dependency
            .watchlistRepository
            .fetch(symbols: symbols)
            .receive(on: RunLoop.main)
            .sink(receiveValue: myWatchlistItemMapper)
            .store(in: &cancellables)
    }
    
    private func connectWebSocket() {
        dependency
            .watchlistRepository
            .connect()
    }
    
    private func disconnectWebSocket() {
        dependency
            .watchlistRepository
            .disconnect()
    }
    
    private func myWatchlistItemMapper(receivedDatum: [Datum]) {
        receivedDatum
            .forEach {[weak self] data in
                guard let self = self else { return }
                //if watchlistItemModels already has the Symbol
                if watchlistItemModels.contains(where: {
                    $0.companyName.uppercased() == data.s
                }) {
                    for (index, model) in self.watchlistItemModels.enumerated() {
                        if model.companyName.uppercased() == data.s {
                            self.watchlistItemModels[index].price = "\(data.p)"
                        }
                    }
                } else {
                    // if WatchlistItemModels are empty
                    self.symbols.forEach { symbol in
                        if "BINANCE:\(symbol.displaySymbol.uppercased())USDT" == data.s {
                            self.watchlistItemModels.append(.init(
                                symbol: symbol.displaySymbol,
                                companyName: data.s,
                                price: "\(data.p)",
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

extension WatchlistInteractor: WatchlistPresentableListener {
    func turnOnSocket() {
        dependency.watchlistRepository.connect()
        fetchFromNetwork(symbols: self.displaySymbols)
    }
    
    func turnOffSocket() {
        dependency.watchlistRepository.disconnect()
    }
    
    func removeItem(at indexPath: IndexPath) {
        //Delete Item from Persistance
        //Delete Item from model (watchlistItemModels)
        
        let deletingSymbol = watchlistItemModels[indexPath.row].symbol
        symbols.removeAll { $0.displaySymbol == deletingSymbol }
        watchlistItemModels.remove(at: indexPath.row)
    }
    
    func didTap(_ index: Int) {
        listener?.watchlistDidTap(StaticSymbols.symbols[index])
    }
    
    func updateSections(completion: ([WatchlistItemModel]) -> Void) {
        completion(watchlistItemModels)
    }
}
