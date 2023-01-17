//
//  CoinDetailViewController.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/07.
//

import ModernRIBs
import UIKit

protocol CoinDetailPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func didTapBackButton()
    func didTapFavoriteButton()
}

final class CoinDetailViewController: UIViewController, CoinDetailPresentable, CoinDetailViewControllable {

    weak var listener: CoinDetailPresentableListener?
    
    var scrollView = UIScrollView()
    private lazy var favoriteButton = UIBarButtonItem(
        image: .init(systemName: ""),
        style: .done,
        target: self,
        action: #selector(favoriteButtonDidTap)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem(with: .back, tintColor: .label, target: self, action: #selector(backButtonDidTap))
    @objc
    private func favoriteButtonDidTap() {
        listener?.didTapFavoriteButton()
    }
    
    @objc
    private func backButtonDidTap() {
        listener?.didTapBackButton()
    }
    
    private var contentView = UIView()
    func update(symbol: SymbolResult) {
        label.text = symbol.symbol
    func doesSymbolInPersistance(_ exist: Bool) {
        favoriteButton.image = .init(systemName: exist ? "star.fill" : "star")
    }
}

extension CoinDetailViewController {
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(UIView())
        favoriteButton.tintColor = .gdacBlue
        navigationItem.rightBarButtonItems = [favoriteButton]
    }
}
