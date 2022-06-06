//
//  NewsRouter.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import ModernRIBs

protocol NewsInteractable: Interactable {
    var router: NewsRouting? { get set }
    var listener: NewsListener? { get set }
}

protocol NewsViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class NewsRouter: ViewableRouter<NewsInteractable, NewsViewControllable>, NewsRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: NewsInteractable, viewController: NewsViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
