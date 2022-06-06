//
//  MainRouter.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import ModernRIBs
import UIKit

protocol MainInteractable: Interactable, WatchlistListener, OpinionsListener, NewsListener {
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
    
    init(
        interactor: MainInteractable,
        viewController: MainViewControllable,
        watchListBuildable: WatchlistBuildable,
        opinionsBuildable: OpinionsBuildable,
        newsBuildable: NewsBuildable
    ) {
        self.watchList = watchListBuildable
        self.opinions = opinionsBuildable
        self.news = newsBuildable
        
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
        if newsRouting != nil {return }
        let router = news.build(withListener: interactor)
        let news = router.viewControllable
        viewController.setNews(news)
        newsRouting = router
        attachChild(router)
    }
}
