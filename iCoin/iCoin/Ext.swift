//
//  Ext.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import UIKit

// MARK: - Add Subview

extension UIView {
    /// Adds multiple subviews
    /// - Parameter views: Collection of subviews
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
