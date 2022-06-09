//
//  OpinionsCell.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import ModernRIBs
import UIKit.UICollectionViewCell

final class OpinionsCell: UICollectionViewCell {
    static let identifier = "OpinionsCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with opinionView: UIView) {
        contentView.addSubviews(opinionView)

        NSLayoutConstraint.activate([
            opinionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            opinionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            opinionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            opinionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
