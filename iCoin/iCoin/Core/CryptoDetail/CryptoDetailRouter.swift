//
//  CryptoDetailRouter.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/12.
//

import ModernRIBs

protocol CryptoDetailInteractable: Interactable {
    var router: CryptoDetailRouting? { get set }
    var listener: CryptoDetailListener? { get set }
}

protocol CryptoDetailViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CryptoDetailRouter: ViewableRouter<CryptoDetailInteractable, CryptoDetailViewControllable>, CryptoDetailRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: CryptoDetailInteractable, viewController: CryptoDetailViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
