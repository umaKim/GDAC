//
//  MainBuilder.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//
import UIKit
import ModernRIBs

protocol MainDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MainComponent: Component<MainDependency>, WatchlistDependency, OpinionsDependency, NewsDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol MainBuildable: Buildable {
    func build(withListener listener: MainListener) -> MainRouting
}

final class MainBuilder: Builder<MainDependency>, MainBuildable {

    override init(dependency: MainDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MainListener) -> MainRouting {
        let component = MainComponent(dependency: dependency)
        let viewController = MainViewController()
        let interactor = MainInteractor(presenter: viewController)
        interactor.listener = listener
        
        let watchlist = WatchlistBuilder(dependency: component)
        let opinions = OpinionsBuilder(dependency: component)
        let news = NewsBuilder(dependency: component)
        
        return MainRouter(
            interactor: interactor,
            viewController: viewController,
            watchList: watchlist,
            opinions: opinions,
            news: news
        )
    }
}
