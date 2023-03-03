//
//  CoinInformationViewController.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/20.
//

import ModernRIBs
import UIKit

protocol CoinInformationPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class CoinInformationViewController: UIViewController, CoinInformationPresentable, CoinInformationViewControllable {
    
    weak var listener: CoinInformationPresentableListener?
    
    private let contentView = CoinInformationView()
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    func update(_ coinDetailMetaViewData: CoinDetailMetaViewData) {
        contentView.update(coinDetailMetaViewData)
    }
}
