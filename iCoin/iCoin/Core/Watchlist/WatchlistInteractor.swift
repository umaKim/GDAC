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
    func watchlistDidTap(_ symbol: CoinCapAsset)
}

protocol WatchlistInteractorDependency {
    var watchlistRepository: WatchlistRepository { get }
    var lifeCycleDidChangePublisher: AnyPublisher<ViewControllerLifeCycle, Never> { get }
}

final class WatchlistInteractor: PresentableInteractor<WatchlistPresentable>, WatchlistInteractable  {
    typealias Symbol = String
    
    weak var router: WatchlistRouting?
    weak var listener: WatchlistListener?
    
    weak var mainInteractorListener: MainListener?
    
    //MARK: - Model
    private var watchlistItemModels: [WatchlistItemModel] = []
    
    private var symbols: [CoinCapAsset] = []
    
    private var displaySymbols: [Symbol] {
        self.symbols.map({ "\($0.symbol.uppercased())" })
    }
    
    private let dependency: WatchlistInteractorDependency
    private var lock = NSLock()
    private var cancellables: Set<AnyCancellable>
    
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
        bind()
    }
    
    override func willResignActive() {
        super.willResignActive()
        cancellables.forEach({$0.cancel()})
        cancellables.removeAll()
    }
}

// MARK: - Life Cycle
extension WatchlistInteractor {
    private func bind() {
        dependency
            .lifeCycleDidChangePublisher
            .sink {[weak self] cycle in
                guard let self = self else { return }
                switch cycle {
                case .viewWillAppear:
                    self.fetchSymbols()
                case .viewWillDisappear:
                    self.disconnectWebSocket()
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Network
extension WatchlistInteractor {
    private func fetchSymbols() {
        dependency
            .watchlistRepository
            .fetchSymbols()
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished fetchSymbols")
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: {[weak self] symbolResponse in
                guard let self = self else { return }
                self.symbols = symbolResponse.data
                self.initialSettingForWatchlistItemModels(with: symbolResponse.data)
                self.fetchFromNetwork(symbols: self.displaySymbols)
            }
            .store(in: &cancellables)
    }
    
    private func fetchFromNetwork(symbols: [Symbol]) {
        connectWebSocket()
        
        dependency
            .watchlistRepository
            .set(symbols: symbols)
        
        dependency
            .watchlistRepository
            .dataPublisher
            .receive(on: DispatchQueue.global())
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finished fetchFromNetwork")
                }
            }, receiveValue: {[weak self] datum in
                guard let self = self else {return }
                self.myWatchlistItemMapper(receivedDatum: datum)
            })
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
}

// MARK: - For Presentable
extension WatchlistInteractor {
    private func reloadData() {
        presenter.reloadData(
            with: watchlistItemModels,
            animation: .none
        )
    }
}

// MARK: - Data Mapper
extension WatchlistInteractor {
    private func initialSettingForWatchlistItemModels(with data: [CoinCapAsset]) {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.watchlistItemModels = data.map({.init(
                symbol: $0.symbol,
                detailName: $0.name,
                price: $0.priceUsd.toDollarDecimal ?? "0",
                changePercentage: $0.changePercent24Hr.toPercentDecimal ?? "0"
            )})
            self.reloadData()
        }
    }
    
    private func myWatchlistItemMapper(receivedDatum: [Datum]) {
        receivedDatum
            .forEach {[weak self] data in
                guard let self = self else { return }
                self.lock.lock()
                defer { self.lock.unlock() }
                
                //if watchlistItemModels already has the Symbol
                if watchlistItemModels.contains(where: {
                    "BINANCE:\($0.symbol.uppercased())USDT" == data.s
                }) {
                    for (index, model) in self.watchlistItemModels.enumerated() {
                        if "BINANCE:\(model.symbol.uppercased())USDT" == data.s {
                            self.watchlistItemModels[index].price = "\(data.p)"
                        }
                    }
                } else {
                    // if WatchlistItemModels are empty
                    self.symbols.forEach { symbol in
                        if "BINANCE:\(symbol.symbol.uppercased())USDT" == data.s {
                            self.watchlistItemModels.append(.init(
                                symbol: symbol.symbol,
                                detailName: symbol.name,
                                price: symbol.priceUsd,
                                changePercentage: symbol.changePercent24Hr.toPercentDecimal ?? "0"
                            ))
                        }
                    }
                }
            }
        DispatchQueue.main.async {[weak self] in
            self?.lock.lock()
            defer { self?.lock.unlock() }
            self?.reloadData()
        }
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
        let deletingSymbol = watchlistItemModels[indexPath.row].symbol
        symbols.removeAll { $0.symbol == deletingSymbol }
        watchlistItemModels.remove(at: indexPath.row)
    }
    
    func didTap(_ index: Int) {
        listener?.watchlistDidTap(symbols[index])
    }
    
    func updateSections(completion: ([WatchlistItemModel]) -> Void) {
        completion(watchlistItemModels)
    }
}
