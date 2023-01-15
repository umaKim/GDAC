//
//  UIViewController+Utils.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/12.
//

import UIKit

enum DissmissButtonType {
    case back, close
    
    var iconSystemName: String {
        switch self {
        case .close:
            return "xmark"
        case .back:
            return "chevron.backward"
        }
    }
}

extension UIViewController {
    func setupNavigationItem(
        with buttonType: DissmissButtonType,
        tintColor: UIColor = .tintColor,
        target: Any?,
        action: Selector?
    ) {
        let bt = UIBarButtonItem(
            image: UIImage(
                systemName: buttonType.iconSystemName,
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)),
            style: .plain,
            target: target,
            action: action
        )
        bt.tintColor = tintColor
        navigationItem.leftBarButtonItem = bt
    }
}
