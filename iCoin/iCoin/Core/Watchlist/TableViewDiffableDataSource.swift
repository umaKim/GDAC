//
//  TableViewDiffableDataSource.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/06.
//

import UIKit
import Combine

enum DiffableDataSourceAction {
    case deleteAt(IndexPath)
}

final class TableViewDiffableDataSource: UITableViewDiffableDataSource<Section, WatchlistItemModel> {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<DiffableDataSourceAction, Never>()
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var snapshot = self.snapshot()
            if let item = itemIdentifier(for: indexPath) {
                snapshot.deleteItems([item])
                apply(snapshot, animatingDifferences: true)
                actionSubject.send(.deleteAt(indexPath))
            }
        }
    }
}
