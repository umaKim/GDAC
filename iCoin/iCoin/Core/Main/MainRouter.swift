//
//  MainRouter.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import ModernRIBs
import UIKit

protocol MainInteractable: Interactable,
                           WatchlistListener,
                           OpinionsListener,
                           NewsListener,
                           SearchListener,
                           CoinDetailListener {
    var router: MainRouting? { get set }
    var listener: MainListener? { get set }
}

protocol MainViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func setWatchlist(_ view: ViewControllable)
    func setOpinion(_ view: ViewControllable)
    func setNews(_ view: ViewControllable)
}

final class MainRouter: ViewableRouter<MainInteractable, MainViewControllable>, MainRouting {
    
    
    private let watchList: WatchlistBuildable
    private var watchListRouting: Routing?
    
    private let opinions: OpinionsBuildable
    private var opinionsRouting: Routing?
    
    private let news: NewsBuildable
    private var newsRouting: Routing?
    
    private let search: SearchBuildable
    private var searchRouting: Routing?
    
    private let coinDetail: CoinDetailBuildable
    private var coinDetailRouting: Routing?
    
    init(
        interactor: MainInteractable,
        viewController: MainViewControllable,
        watchListBuildable: WatchlistBuildable,
        opinionsBuildable: OpinionsBuildable,
        newsBuildable: NewsBuildable,
        searchBuildable: SearchBuildable,
        coinDetailBuildable: CoinDetailBuildable
    ) {
        self.watchList = watchListBuildable
        self.opinions = opinionsBuildable
        self.news = newsBuildable
        self.search = searchBuildable
        self.coinDetail = coinDetailBuildable
        
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
    
    func attachOpinion() {
        if opinionsRouting != nil { return }
        let router = opinions.build(withListener: interactor)
        let opinion = router.viewControllable
        viewController.setOpinion(opinion)
        opinionsRouting = router
        attachChild(router)
    }
    
    func attachNews() {
        if newsRouting != nil { return }
        let router = news.build(withListener: interactor)
        let news = router.viewControllable
        viewController.setNews(news)
        newsRouting = router
        attachChild(router)
    }
    
    func attachSearch() {
        if searchRouting != nil { return }
        let router = search.build(withListener: interactor)
        let search = router.viewControllable
        viewControllable.pushViewController(search, animated: true)
        searchRouting = router
        attachChild(router)
    }
    
    func detachSearch() {
        guard let router = searchRouting else { return }
        viewControllable.popViewController(animated: true)
        detachChild(router)
        searchRouting = nil
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
