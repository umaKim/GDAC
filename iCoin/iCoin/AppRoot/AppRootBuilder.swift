//
//  AppRootBuilder.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//
import Combine
import ModernRIBs
import UIKit

protocol AppRootDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AppRootComponent: Component<AppRootDependency>, MainDependency, PortfolioDependency {
    
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol AppRootBuildable: Buildable {
    func build() -> LaunchRouting
}

final class AppRootBuilder: Builder<AppRootDependency>, AppRootBuildable {

    override init(dependency: AppRootDependency) {
        super.init(dependency: dependency)
    }
    
    func build() -> LaunchRouting {
        let component = AppRootComponent(dependency: dependency)
//        let viewController = AppRootViewController()
        let viewController = RootTabBarController()
        let interactor = AppRootInteractor(presenter: viewController)
        
        let main = MainBuilder(dependency: component)
        let protfolio = PortfolioBuilder(dependency: component)
        
        let router = AppRootRouter(
            interactor: interactor,
            viewController: viewController,
            main: main,
            portfolio: protfolio
        )
        
        return router
    }
}
