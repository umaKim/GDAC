//
//  OrderBookInteractor.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/23.
//

import ModernRIBs

protocol OrderBookRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol OrderBookPresentable: Presentable {
    var listener: OrderBookPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol OrderBookListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class OrderBookInteractor: PresentableInteractor<OrderBookPresentable>, OrderBookInteractable, OrderBookPresentableListener {

    weak var router: OrderBookRouting?
    weak var listener: OrderBookListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: OrderBookPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
