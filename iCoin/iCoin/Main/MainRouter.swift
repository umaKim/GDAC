//
//  MainRouter.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import ModernRIBs
import UIKit

protocol MainInteractable: Interactable {
    var router: MainRouting? { get set }
    var listener: MainListener? { get set }
}

protocol MainViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MainRouter: ViewableRouter<MainInteractable, MainViewControllable>, MainRouting {
    
    private let watchList: UIViewController
    private let opinions: UIViewController
    private let news: UIViewController
    
    init(
        interactor: MainInteractable,
        viewController: MainViewControllable,
        watchList: UIViewController,
        opinions: UIViewController,
        news: UIViewController
    ) {
        self.watchList = watchList
        self.opinions = opinions
        self.news = news
        
        super.init(interactor: interactor, viewController: viewController)
    }
    
    func attachControllers() {
        
    }
}
