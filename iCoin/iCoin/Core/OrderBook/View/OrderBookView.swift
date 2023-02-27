//
//  OrderBookView.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/23.
//

import UIKit

final class OrderBookView: UIView {
    
    // MARK: - UI Object
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OrderBookBidTableViewCell.self, forCellReuseIdentifier: OrderBookBidTableViewCell.identifier)
        tableView.register(OrderBookAskTableViewCell.self, forCellReuseIdentifier: OrderBookAskTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubviews(tableView)
        tableView.backgroundColor = .green
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
