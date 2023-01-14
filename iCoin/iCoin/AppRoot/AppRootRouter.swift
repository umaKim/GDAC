//
//  AppRootRouter.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import ModernRIBs

protocol AppRootInteractable: Interactable, MainListener, PortfolioListener {
    var router: AppRootRouting? { get set }
    var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func setViewControllers(_ viewControllers: [ViewControllable])
}

final class AppRootRouter: LaunchRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {
    private let main: MainBuildable
    private let portfolio: PortfolioBuildable
    
    init(
        interactor: AppRootInteractor,
        viewController: AppRootViewControllable,
        main: MainBuildable,
        portfolio: PortfolioBuildable
    ) {
        self.main = main
        self.portfolio = portfolio
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachController() {
        let appHomeRouting = main.build(withListener: interactor)
//        let portfolio = portfolio.build(withListener: interactor)
        
        attachChild(appHomeRouting)
//        attachChild(portfolio)
        
        let viewControllers = [
            NavigationControllerable(root: appHomeRouting.viewControllable),
//            NavigationControllerable(root: portfolio.viewControllable)
        ]
        viewController.setViewControllers(viewControllers)
    }
}
