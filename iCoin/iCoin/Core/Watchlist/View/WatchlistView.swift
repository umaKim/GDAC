//
//  WatchlistView.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/06.
//

import UIKit.UITableView

final class WatchlistView: BaseView {
    //MARK: - UI Object
    private(set) lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(WatchlistItemCell.self,
                    forCellReuseIdentifier: WatchlistItemCell.identifier)
        return tv
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - setup UI
extension WatchlistView {
    private func setupUI() {
        addSubviews(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
