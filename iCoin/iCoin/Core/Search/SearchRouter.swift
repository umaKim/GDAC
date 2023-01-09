//
//  SearchRouter.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/12.
//

import ModernRIBs

protocol SearchInteractable: Interactable, CoinDetailListener {
    var router: SearchRouting? { get set }
    var listener: SearchListener? { get set }
}

protocol SearchViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SearchRouter: ViewableRouter<SearchInteractable, SearchViewControllable>, SearchRouting {
    private let coinDetail: CoinDetailBuildable
    private var coinDetailRouting: Routing?
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: SearchInteractable,
        viewController: SearchViewControllable,
        coinDetail: CoinDetailBuildable
    ) {
        self.coinDetail = coinDetail
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
