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
        navigationItem.title = "Portfolio"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listener?.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener?.viewDidDisappear()
    }
    
    func setWatchlist(_ viewControllerable: ViewControllable) {
        guard let watchlistView = viewControllerable.uiviewController.view else { return }
        view.addSubviews(watchlistView)
        NSLayoutConstraint.activate([
            watchlistView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            watchlistView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            watchlistView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            watchlistView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
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
