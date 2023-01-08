//
//  CoinDetailRouter.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/07.
//

import ModernRIBs

protocol CoinDetailInteractable: Interactable {
    var router: CoinDetailRouting? { get set }
    var listener: CoinDetailListener? { get set }
}

protocol CoinDetailViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CoinDetailRouter: ViewableRouter<CoinDetailInteractable, CoinDetailViewControllable>, CoinDetailRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(
        interactor: CoinDetailInteractable,
        viewController: CoinDetailViewControllable
    ) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
