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
//    func setViews(viewControllerable: ViewControllable...)
    
    func setViews(watchlist: ViewControllable, opinions: ViewControllable, news: ViewControllable)
}

final class MainRouter: ViewableRouter<MainInteractable, MainViewControllable>, MainRouting {
    
    private let watchList: WatchlistBuildable
    private let opinions: OpinionsBuildable
    private let news: NewsBuildable
    
    init(
        interactor: MainInteractable,
        viewController: MainViewControllable,
        watchList: WatchlistBuildable,
        opinions: OpinionsBuildable,
        news: NewsBuildable
    ) {
        self.watchList = watchList
        self.opinions = opinions
        self.news = news
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachControllers() {
//        let watchlistRouting = watchList.build(withListener: interactor)
//        let opinionsRouting = opinions.build(withListener: interactor)
//        let newsRouting = news.build(withListener: interactor)
//
//        viewController.setViews(watchlist: watchlistRouting.viewControllable,
//                                opinions: opinionsRouting.viewControllable,
//                                news: newsRouting.viewControllable)
    }
}
