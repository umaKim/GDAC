//
//  AppRootRouter.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import ModernRIBs

protocol AppRootInteractable: Interactable, MainListener {
    var router: AppRootRouting? { get set }
    var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func replaceScreen(viewController: ViewControllable)
}

final class AppRootRouter: LaunchRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {
   
    private let main: MainBuildable
    
    init(
        interactor: AppRootInteractor,
        viewController: AppRootViewControllable,
        main: MainBuildable
    ) {
        self.main = main
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachController() {
        let appHomeRouting = main.build(withListener: interactor)
        
        attachChild(appHomeRouting)
        
        viewController.replaceScreen(viewController: NavigationControllerable(root: appHomeRouting.viewControllable))
    }
}
