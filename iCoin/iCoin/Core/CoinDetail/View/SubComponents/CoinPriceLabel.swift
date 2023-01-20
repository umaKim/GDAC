//
//  CoinPriceLabel.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/17.
//

import UIKit

final class CoinPriceLabel: UIView {
    private lazy var priceLabel: UILabel = {
        let lb = UILabel()
        lb.font = .boldSystemFont(ofSize: 30)
        lb.text = "-"
        return lb
    }()
    
    private lazy var percentChangeLabel: UILabel = {
        let lb = UILabel()
        lb.font = .boldSystemFont(ofSize: 16)
        lb.text = "-"
        return lb
    }()
    
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with data: CoinPriceLabelData) {
        self.priceLabel.text = data.price
        self.percentChangeLabel.text = data.priceChnagePercentage
    }
}

// MARK: - Set up UI
extension CoinPriceLabel {
    private func setupLayout() {
        let sv = UIStackView(arrangedSubviews: [priceLabel, percentChangeLabel])
        sv.axis = .vertical
        sv.alignment = .leading
        sv.distribution = .fillProportionally
        addSubviews(sv)
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: leadingAnchor),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor),
            sv.topAnchor.constraint(equalTo: topAnchor),
            sv.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
