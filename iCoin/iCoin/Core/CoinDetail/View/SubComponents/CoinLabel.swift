//
//  CoinLabel.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/17.
//

import UIKit

final class CoinLabel: UIView {
    private lazy var logoImageView: UIImageView = {
        let uv = UIImageView()
        return uv
    }()
    
    private lazy var nameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "-"
        lb.font = .boldSystemFont(ofSize: 18)
        return lb
    }()
    
    private lazy var symbolLabel: UILabel = {
        let lb = UILabel()
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
    
    public func configure(with data: CoinLabelData) {
        self.logoImageView.image = data.image
        self.nameLabel.text = data.name
        self.symbolLabel.text = data.symbol.uppercased()
    }
}

// MARK: - Set up UI
extension CoinLabel {
    private func setupLayout() {
        let verticalSv = UIStackView(arrangedSubviews: [nameLabel, symbolLabel])
        verticalSv.axis = .vertical
    
        let horizontalSv = UIStackView(arrangedSubviews: [logoImageView, verticalSv])
        horizontalSv.axis = .horizontal
        horizontalSv.spacing = 16
        
        addSubviews(horizontalSv)
        
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 50),
            logoImageView.heightAnchor.constraint(equalToConstant: 50),
            
            horizontalSv.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalSv.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalSv.bottomAnchor.constraint(equalTo: bottomAnchor),
            horizontalSv.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}
