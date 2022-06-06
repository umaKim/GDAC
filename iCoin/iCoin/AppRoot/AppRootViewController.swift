//
//  AppRootViewController.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import ModernRIBs
import UIKit

protocol AppRootPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class AppRootViewController: UIViewController, AppRootPresentable, AppRootViewControllable {
   
    weak var listener: AppRootPresentableListener?
    
    func replaceScreen(viewController: ViewControllable) {
        viewController.uiviewController.willMove(toParent: self)
        addChild(viewController.uiviewController)
        view.addSubview(viewController.uiviewController.view)
        
        NSLayoutConstraint.activate([
            viewController.uiviewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewController.uiviewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewController.uiviewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewController.uiviewController.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
}
