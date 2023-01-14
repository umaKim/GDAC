//
//  PortfolioViewController.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/14.
//

import ModernRIBs
import UIKit

protocol PortfolioPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    
    func viewDidAppear()
    func viewDidDisappear()
}

final class PortfolioViewController: UIViewController, PortfolioPresentable, PortfolioViewControllable {
    
    weak var listener: PortfolioPresentableListener?
    
    private let contentView = PortfolioView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupTabBarItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listener?.viewDidAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        listener?.viewDidDisappear()
    }
    
    func setMyWatchList(_ viewControllerable: ViewControllable) {
        
    }
}

extension PortfolioViewController: TabBarItemSettable {
    private func setupTabBarItem() {
        setupTabBarItem(
            title: "Portfolio",
            image: UIImage(systemName: "star"),
            selectedImage: UIImage(systemName: "star.fill")
        )
    }
}
