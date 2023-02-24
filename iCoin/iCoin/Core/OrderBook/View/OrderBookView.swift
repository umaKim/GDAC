//
//  OrderBookView.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/23.
//

import UIKit

final class OrderBookView: UIView {
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
