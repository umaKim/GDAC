//
//  File.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/16.
//

import UIKit

// MARK: - Space in the front textfield
extension UITextField {
  func addLeftPadding() {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = ViewMode.always
  }
}
