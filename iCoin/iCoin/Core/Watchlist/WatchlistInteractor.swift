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
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    //    func didTapEdittingButton()
}

protocol WatchlistInteractorDependency {
    var watchlistRepository: WatchlistRepository { get }
    var edittingButtonDidTap: AnyPublisher<Void, Never> { get }
    var mainViewLifeCycleDidChange: AnyPublisher<MainViewLifeCycle, Never> { get }
}

final class WatchlistInteractor: PresentableInteractor<WatchlistPresentable>, WatchlistInteractable  {
    
    weak var router: WatchlistRouting?
    weak var listener: WatchlistListener?
    
    weak var mainInteractorListener: MainListener?
    
    //MARK: - Model
    private var watchlistChartMap: [String: [CandleStick]] = [:]
    private var watchlistQuoteMap: [String: Quote] = [:]
    private(set) var watchlistItemModels: [WatchlistItemModel] = []
    
    //TODO: This should be fetched from Network
    private var symbols: [String] = [
        "BTC",
        "ETH",
        "XRP"
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

        bind()
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
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
                guard let self = self else {return }
                print("mainViewLifeCycleDidChange")
                switch cycle {
                case .viewDidAppear:
                    print("mainViewLifeCycleDidChange viewDidAppear")
                    self.fetchFromNetwork(symbols: self.symbols)
                    break
                    
                case .viewDidDisappear:
                    print("mainViewLifeCycleDidChange viewDidDisappear")
                    self.stopFetch()
                }
            }
            .store(in: &cancellables)
    }
    
    typealias Symbol = String
    typealias Price = Double
    
    private var currentPrice: [Symbol: Price] = [:]
    
    private func fetchFromNetwork(symbols: [Symbol]) {
        dependency
            .watchlistRepository
            .fetch(symbols: symbols)
            .receive(on: RunLoop.main)
            .sink { [weak self] datum in
                self?.myWatchlistItemMapper(receivedDatum: datum)
            }
            .store(in: &cancellables)
    }
    
    private func stopFetch() {
        dependency.watchlistRepository.stopFetch()
    }
    
    private func myWatchlistItemMapper(receivedDatum: [Datum]) {
        receivedDatum.forEach { data in
            //if watchlistItemModels already has the Symbol
            if watchlistItemModels.contains(where: {
                $0.companyName.uppercased() == data.s
            }) {
                for (index, model) in self.watchlistItemModels.enumerated() {
                    if model.companyName.uppercased() == data.s {
                        self.watchlistItemModels[index].price = "$\(data.p)"
                        self.watchlistItemModels[index].changeColor = changeColorComparing(data)
                    }
                }
            } else {
            // if WatchlistItemModels are empty
                self.symbols.forEach { symbol in
                    if "BINANCE:\(symbol.uppercased())USDT" == data.s {
                        self.watchlistItemModels.append(.init(symbol: symbol,
                                                              companyName: data.s,
                                                              price: "$\(data.p)",
                                                              changeColor: .clear,
                                                              changePercentage: "0.5"))
                    }
                }
            }
            
            self.currentPrice[data.s] = data.p
        }
        self.presenter.reloadData(with: self.watchlistItemModels, animation: .none)
    }
    
    private func changeColorComparing(_ data: Datum) -> UIColor {
//        currentPrice[data.s] ?? 0 < data.p ? .systemGreen : .systemRed
//        guard let currentPrice = currentPrice else {return .clear}
        
        if currentPrice[data.s] ?? 0 < data.p {
            return .systemGreen
        } else if currentPrice[data.s] ?? 0 > data.p {
            return .systemRed
        }
        
        return .clear
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
    
    func didTap() {
        listener?.watchlistDidTap()
    }
    
    func updateSections(completion: ([WatchlistItemModel]) -> Void) {
        completion(watchlistItemModels)
    }
}
