//
//  OrderBookRouter.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/23.
//

import ModernRIBs

protocol OrderBookInteractable: Interactable {
    var router: OrderBookRouting? { get set }
    var listener: OrderBookListener? { get set }
}

protocol OrderBookViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class OrderBookRouter: ViewableRouter<OrderBookInteractable, OrderBookViewControllable>, OrderBookRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: OrderBookInteractable, viewController: OrderBookViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
