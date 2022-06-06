//
//  OpinionsRouter.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import ModernRIBs

protocol OpinionsInteractable: Interactable {
    var router: OpinionsRouting? { get set }
    var listener: OpinionsListener? { get set }
}

protocol OpinionsViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class OpinionsRouter: ViewableRouter<OpinionsInteractable, OpinionsViewControllable>, OpinionsRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: OpinionsInteractable, viewController: OpinionsViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
