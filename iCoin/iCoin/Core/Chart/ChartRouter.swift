//
//  ChartRouter.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/20.
//

import ModernRIBs

protocol ChartInteractable: Interactable {
    var router: ChartRouting? { get set }
    var listener: ChartListener? { get set }
}

protocol ChartViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ChartRouter: ViewableRouter<ChartInteractable, ChartViewControllable>, ChartRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ChartInteractable, viewController: ChartViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
