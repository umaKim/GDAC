//
//  MyWatchListRouter.swift
//  iCoin
//
//  Created by 김윤석 on 2022/11/20.
//

import ModernRIBs

protocol MyWatchListInteractable: Interactable, CoinDetailListener {
    var router: MyWatchListRouting? { get set }
    var listener: MyWatchListListener? { get set }
}

protocol MyWatchListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MyWatchListRouter: ViewableRouter<MyWatchListInteractable, MyWatchListViewControllable>, MyWatchListRouting {

    private let coinDetail: CoinDetailBuildable
    private var coinDetailRouting: Routing?
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: MyWatchListInteractable,
        viewController: MyWatchListViewControllable,
        coinDetailBuildable: CoinDetailBuildable
    ) {
        self.coinDetail = coinDetailBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachCoinDetail() {
        if coinDetailRouting != nil { return }
        let router = coinDetail.build(withListener: interactor)
        let coinDetail = router.viewControllable
        viewControllable.pushViewController(coinDetail, animated: true)
        coinDetailRouting = router
        attachChild(router)
    }
    
    func detachCoinDetail() {
        guard let router = coinDetailRouting else { return }
        viewControllable.popViewController(animated: true)
        detachChild(router)
        coinDetailRouting = nil
    }
}
