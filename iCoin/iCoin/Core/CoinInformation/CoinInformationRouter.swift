//
//  CoinInformationRouter.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/20.
//

import ModernRIBs

protocol CoinInformationInteractable: Interactable {
    var router: CoinInformationRouting? { get set }
    var listener: CoinInformationListener? { get set }
}

protocol CoinInformationViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CoinInformationRouter: ViewableRouter<CoinInformationInteractable, CoinInformationViewControllable>, CoinInformationRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: CoinInformationInteractable, viewController: CoinInformationViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
