//
//  CoinDetailMetaView.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/18.
//

import UIKit

final class CoinDetailMetaView: UIView {
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.text = "Meta Data"
        return label
    }()
    
    private var collectionViewLayout: UICollectionViewLayout {
        let width                   = UIScreen.main.bounds.width
        let padding: CGFloat        = 16 + 8
        let minimumInsets: CGFloat  = 10
        var itemWidth               = width - (padding * 2) - (minimumInsets * 2)
        itemWidth                   = (itemWidth) / 2
        let flowLayout              = UICollectionViewFlowLayout()
        flowLayout.sectionInset     = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        flowLayout.itemSize         = CGSize(width: itemWidth, height: itemWidth/2)
        flowLayout.scrollDirection  = .vertical
        return flowLayout
    }
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        cv.register(CoinDetailMetaInfoCell.self, forCellWithReuseIdentifier: CoinDetailMetaInfoCell.identifier)
        cv.dataSource = self
        cv.backgroundColor = .systemBackground
        return cv
    }()
    
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    private var data: CoinDetailMetaViewData?
    
    public func configure(with data: CoinDetailMetaViewData) {
        self.data = data
        self.descriptionLabel.text = data.description.htmlToString
        collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Set up UI
extension CoinDetailMetaView {
    private func setupLayout() {
        let cvheight = (((UIScreen.main.bounds.width - 20) / 2) * 5)/2
        addSubviews(titleLabel, descriptionLabel, collectionView)
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: cvheight),
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension CoinDetailMetaView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data?.metaDatum.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CoinDetailMetaInfoCell.identifier,
                for: indexPath
            ) as? CoinDetailMetaInfoCell,
            let data = data?.metaDatum[indexPath.item]
        else { return UICollectionViewCell() }
        cell.configure(with: data)
        return cell
    }
}
