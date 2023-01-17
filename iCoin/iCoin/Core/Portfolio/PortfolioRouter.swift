//
//  PortfolioRouter.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/14.
//

import ModernRIBs

protocol PortfolioInteractable: Interactable,
                                WatchlistListener,
                                CoinDetailListener {
    var router: PortfolioRouting? { get set }
    var listener: PortfolioListener? { get set }
}

protocol PortfolioViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func setWatchlist(_ viewControllerable: ViewControllable)
}

final class PortfolioRouter: ViewableRouter<PortfolioInteractable, PortfolioViewControllable>, PortfolioRouting {
    
    private let watchList: WatchlistBuildable
    private var watchListRouting: Routing?
    
    private let coinDetail: CoinDetailBuildable
    private var coinDetailRouting: Routing?
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: PortfolioInteractable,
        viewController: PortfolioViewControllable,
        watchlist: WatchlistBuildable,
        coinDetail: CoinDetailBuildable
    ) {
        self.watchList = watchlist
        self.coinDetail = coinDetail
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachWatchlist() {
        if watchListRouting != nil { return }
        let router = watchList.build(withListener: interactor)
        let watchlist = router.viewControllable
        viewController.setWatchlist(watchlist)
        watchListRouting = router
        attachChild(router)
    }
    
    func attachCoinDetail() {
        if coinDetailRouting != nil { return }
        let router = coinDetail.build(withListener: interactor)
        let coinDetail = router.viewControllable
        router.viewControllable.hidesBottomBarWhenPushed = true
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
