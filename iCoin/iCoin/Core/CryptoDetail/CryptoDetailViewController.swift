//
//  CryptoDetailViewController.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/12.
//

import ModernRIBs
import UIKit

protocol CryptoDetailPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class CryptoDetailViewController: UIViewController, CryptoDetailPresentable, CryptoDetailViewControllable {

    weak var listener: CryptoDetailPresentableListener?
}
