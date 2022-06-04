//
//  WatchlistRouter.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import ModernRIBs

protocol WatchlistInteractable: Interactable {
    var router: WatchlistRouting? { get set }
    var listener: WatchlistListener? { get set }
}

protocol WatchlistViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class WatchlistRouter: ViewableRouter<WatchlistInteractable, WatchlistViewControllable>, WatchlistRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: WatchlistInteractable, viewController: WatchlistViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
