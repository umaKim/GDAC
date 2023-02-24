//
//  OrderBookViewController.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/23.
//

import ModernRIBs
import UIKit

protocol OrderBookPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class OrderBookViewController: UIViewController, OrderBookPresentable, OrderBookViewControllable {

    weak var listener: OrderBookPresentableListener?
    
    private let contentView = OrderBookView()
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
}
