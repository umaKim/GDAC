//
//  OrderBookBuilder.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/23.
//
import Combine
import ModernRIBs

protocol OrderBookDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
    var symbol: AnyPublisher<CoinCapAsset, Never> { get }
}

final class OrderBookComponent: Component<OrderBookDependency>,
                                OrderBookInteractorDependency {
    var symbol: AnyPublisher<CoinCapAsset, Never> { dependency.symbol }
    let orderBookRepository: CoinOrderBookRepository
    
    init(
        dependency: OrderBookDependency,
        orderBookRepository: CoinOrderBookRepository
    ) {
        self.orderBookRepository = orderBookRepository
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol OrderBookBuildable: Buildable {
    func build(withListener listener: OrderBookListener) -> OrderBookRouting
}

final class OrderBookBuilder: Builder<OrderBookDependency>, OrderBookBuildable {

    override init(dependency: OrderBookDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: OrderBookListener) -> OrderBookRouting {
        let component = OrderBookComponent(
            dependency: dependency,
            orderBookRepository:
                CoinOrderBookRepositoryImp(network: NetworkManager())
        )
        let viewController = OrderBookViewController()
        let interactor = OrderBookInteractor(
            dependency: component,
            presenter: viewController
        )
        interactor.listener = listener
        return OrderBookRouter(
            interactor: interactor,
            viewController: viewController
        )
    }
}
