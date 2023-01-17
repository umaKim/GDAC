//
//  WritingOpinionRouter.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/16.
//

import ModernRIBs

protocol WritingOpinionInteractable: Interactable {
    var router: WritingOpinionRouting? { get set }
    var listener: WritingOpinionListener? { get set }
}

protocol WritingOpinionViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class WritingOpinionRouter: ViewableRouter<WritingOpinionInteractable, WritingOpinionViewControllable>, WritingOpinionRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: WritingOpinionInteractable, viewController: WritingOpinionViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
