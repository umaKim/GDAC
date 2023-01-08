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
}

final class CoinDetailViewController: UIViewController, CoinDetailPresentable, CoinDetailViewControllable {

    weak var listener: CoinDetailPresentableListener?
    
    var scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem(with: .back, tintColor: .label, target: self, action: #selector(backButtonDidTap))
    }
    
    @objc
    private func backButtonDidTap() {
        listener?.didTapBackButton()
    }
    
    private var contentView = UIView()
}

extension CoinDetailViewController {
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(UIView())
    }
}
