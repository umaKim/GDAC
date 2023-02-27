//
//  CoinDetailMetaInfoCell.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/21.
//

import UIKit

final class CoinDetailMetaInfoCell: UICollectionViewCell {
    static let identifier = "CoinDetailMetaInfoCell"
    
    private lazy var titleLabel: UILabel = {
       let lb = UILabel()
        lb.font = .boldSystemFont(ofSize: 13)
        lb.minimumScaleFactor = 0.5
        lb.adjustsFontSizeToFitWidth = true
        lb.textColor = .label
        return lb
    }()
    
    private lazy var valueLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 13)
        lb.minimumScaleFactor = 0.5
        lb.adjustsFontSizeToFitWidth = true
        lb.textColor = .label
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with data: MetaData) {
        self.titleLabel.text = data.title
        self.valueLabel.text = data.value
    }
    
    private func layout() {
        contentView.backgroundColor = .gdacBlue.withAlphaComponent(0.5)
        contentView.layer.cornerRadius = 6
        contentView.addSubviews(titleLabel, valueLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
