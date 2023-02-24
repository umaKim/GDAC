//
//  OrderBookBuilder.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/23.
//

import ModernRIBs

protocol OrderBookDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class OrderBookComponent: Component<OrderBookDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
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
        let component = OrderBookComponent(dependency: dependency)
        let viewController = OrderBookViewController()
        let interactor = OrderBookInteractor(presenter: viewController)
        interactor.listener = listener
        return OrderBookRouter(interactor: interactor, viewController: viewController)
    }
}
