//
//  WatchlistCell.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import ModernRIBs
import UIKit.UICollectionViewCell

final class WatchlistCell: UICollectionViewCell {
    static let identifier = "WatchlistCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with watchlistView: UIView) {
        contentView.addSubviews(watchlistView)

        NSLayoutConstraint.activate([
            watchlistView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            watchlistView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            watchlistView.topAnchor.constraint(equalTo: contentView.topAnchor),
            watchlistView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
