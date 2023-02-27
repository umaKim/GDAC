//
//  CoinInformationView.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/20.
//
import UIKit

final class CoinInformationView: UIView {
    init() {
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var contentScrollView = UIScrollView()
    private var contentView = UIView()
    
    private lazy var metaView = CoinDetailMetaView()
    
    func update(_ data: CoinDetailMetaViewData) {
        self.metaView.configure(with: data)
    }
}

extension CoinInformationView {
    private func setupUI() {
        backgroundColor = .systemBackground
        addSubviews(contentScrollView)
        contentScrollView.addSubviews(contentView)
        contentView.addSubviews(metaView)

        NSLayoutConstraint.activate([
            contentScrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor),
            metaView.topAnchor.constraint(equalTo: contentView.topAnchor),
            metaView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            metaView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            metaView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
