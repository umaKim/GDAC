//
//  WatchlistViewController.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import ModernRIBs
import Combine
import UIKit

protocol WatchlistPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    func didTap(indexPath: IndexPath)
    func updateSections(completion: ([WatchlistItemModel]) -> Void)
    func removeItem(at indexPath: IndexPath)
}

enum Section: CaseIterable {
    case main
}

final class WatchlistViewController: UIViewController, WatchlistPresentable, WatchlistViewControllable {
   
    private typealias DataSource = TableViewDiffableDataSource
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, WatchlistItemModel>
    
    weak var listener: WatchlistPresentableListener?
    
    private var dataSource: DataSource?
    
    private let contentView = WatchlistView()
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = contentView
        
        configureTableViewDataSource()
        bind()
    }
    
    private func bind() {
        dataSource?
            .actionPublisher
            .sink(receiveValue: { action in
                switch action {
                case .deleteAt(let index):
                    print(index)
                    self.listener?.removeItem(at: index)
                }
            })
            .store(in: &cancellables)
    }
    
    func reloadData() {
        updateSections()
    }
    
    func setTableEdittingMode() {
        contentView.tableView.setEditing(!contentView.tableView.isEditing,
                                         animated: true)
    }
    
    private func updateSections() {
        listener?.updateSections(completion: {stocks in
            var snapshot = Snapshot()
            snapshot.appendSections([.main])
            snapshot.appendItems(stocks)
            dataSource?.apply(snapshot, animatingDifferences: true)
            dataSource?.defaultRowAnimation = .left
        })
    }
    
    private func setTableViewEditingMode() {
        contentView.tableView.setEditing(!contentView.tableView.isEditing,
                                         animated: true)
    }
}

//MARK: - UITableViewDataSource
extension WatchlistViewController {
    private func configureTableViewDataSource() {
        contentView.tableView.delegate = self
        dataSource = .init(tableView: contentView.tableView,
                           cellProvider: { ( tableView, indexPath, item) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WatchlistItemCell.identifier, for: indexPath) as? WatchlistItemCell else {return nil}
//            cell.configure(with: item)
            return cell
        })
    }
}

extension WatchlistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        listener?.didTap(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WatchlistItemCell.preferredHeight
    }
}