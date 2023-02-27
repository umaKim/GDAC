//
//  OrderBookInteractor.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/23.
//
import Combine
import ModernRIBs
import Foundation

protocol OrderBookRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol OrderBookPresentable: Presentable {
    var listener: OrderBookPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func ordeBookData(_ data: OrderBookData)
//    func updateOrderBookData(with data: [OrderBook], for section: OrderBookViewController.Section)
    func updateOrderBookData(with bids: [OrderBook], asks: [OrderBook])
}

protocol OrderBookListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol OrderBookInteractorDependency {
    var symbol: AnyPublisher<CoinCapAsset, Never> { get }
    var orderBookRepository: CoinOrderBookRepository { get }
}

final class OrderBookInteractor: PresentableInteractor<OrderBookPresentable>, OrderBookInteractable, OrderBookPresentableListener {

    weak var router: OrderBookRouting?
    weak var listener: OrderBookListener?

    private let dependency: OrderBookInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        dependency: OrderBookInteractorDependency,
        presenter: OrderBookPresentable
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
        
        dependency
            .symbol
            .sink {[weak self] coin in
                self?.fetchOrderBook(of: coin.symbol + "_KRW")
            }
            .store(in: &cancellables)
    }
    
    private var data: OrderBookData?
    
    private func fetchOrderBook(of symbol: String) {
        dependency
            .orderBookRepository
            .fetchOrderBook(of: symbol)
            .sink { comple in
                switch comple {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print(error)
                    print(error.localizedDescription)
                }
            } receiveValue: {[weak self] response in
                guard let self = self else { return }
//                self.orderBookData = response.data
//                self.data = response.data
                DispatchQueue.main.async {
//                    self.presenter.ordeBookData(response.data)
                    print(response.data.asks)
                    print(response.data.bids)
//                    self.presenter.updateOrderBookData(with: response.data.asks, for: .ask)
//                    self.presenter.updateOrderBookData(with: response.data.bids, for: .bid)
                    self.presenter.updateOrderBookData(
                        with: response.data.bids,
                        asks: response.data.asks
                    )
                }
            }
            .store(in: &cancellables)
    }
    
//    private var orderBookData: OrderBookData?

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
