//
//  SearchView.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/12.
//

import UIKit.UIView

final class SearchView: BaseView {
    //MARK: - UI Object
    private(set) lazy var tableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
        tableView.rowHeight = SearchCell.prefferedHeight
        
        setupUI()
    }
    
    private func setupUI() {
        addSubviews(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
