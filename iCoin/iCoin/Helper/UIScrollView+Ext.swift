//
//  UIScrollView+Ext.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/27.
//

import UIKit

extension UIScrollView {
    func scrollToCenter() {
        let centerOffset = CGPoint(x: 0, y: (contentSize.height - bounds.size.height) / 2.2)
        setContentOffset(centerOffset, animated: false)
    }
}
