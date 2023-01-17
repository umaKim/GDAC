//
//  CoinDetailViewController.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/07.
//
import Combine
import ModernRIBs
import UIKit
import SwiftUI

protocol CoinDetailPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func didTapBackButton()
    func didTapFavoriteButton()
}

final class CoinDetailViewController: UIViewController, CoinDetailPresentable, CoinDetailViewControllable {
    
    weak var listener: CoinDetailPresentableListener?
    
    private lazy var favoriteButton = UIBarButtonItem(
        image: .init(systemName: ""),
        style: .done,
        target: self,
        action: #selector(favoriteButtonDidTap)
    )
    
    var contentScrollView = UIScrollView()
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem(
            with: .back,
            tintColor: .label,
            target: self,
            action: #selector(backButtonDidTap)
        )
        
        setupUI()
    }
    
    @objc
    private func favoriteButtonDidTap() {
        listener?.didTapFavoriteButton()
    }
    
    @objc
    private func backButtonDidTap() {
        listener?.didTapBackButton()
    }
    
    private var contentView = UIView()
    
    private lazy var label: UILabel = UILabel()
    
    func update(symbol: SymbolResult) {
        label.numberOfLines = 5
        label.text = "\(symbol.symbol)\n\(symbol.displaySymbol)\n\(symbol.description)"
    }
    
    func doesSymbolInPersistance(_ exist: Bool) {
        favoriteButton.image = .init(systemName: exist ? "star.fill" : "star")
    }
}

extension CoinDetailViewController {
    private func setupUI() {
        
        let chartView = UIHostingController(rootView: ChartView())
        guard let chartView = chartView.view else { return }
        
        favoriteButton.tintColor = .gdacBlue
        navigationItem.rightBarButtonItems = [favoriteButton]
        
        view.backgroundColor = .brown
        view.addSubviews(contentScrollView)
        contentScrollView.addSubviews(contentView)
        contentView.addSubviews(label, chartView)
        
        label.textColor = .red
        
        NSLayoutConstraint.activate([
            contentScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: contentScrollView.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentScrollView.safeAreaLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor),
            
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            chartView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            chartView.topAnchor.constraint(equalTo: label.bottomAnchor)
        ])
    }
}
