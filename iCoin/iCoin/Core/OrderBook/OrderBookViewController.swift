//
//  OrderBookViewController.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/23.
//

import ModernRIBs
import UIKit

protocol OrderBookPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class OrderBookViewController: UIViewController, OrderBookPresentable, OrderBookViewControllable {
   
    private typealias DataSource = UITableViewDiffableDataSource<Section, OrderBook>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, OrderBook>
    
    private var dataSource: DataSource?
    
    enum Section: Int, CaseIterable, Hashable {
        case ask
        case bid
    }
    
    weak var listener: OrderBookPresentableListener?
    
    private let contentView = OrderBookView()
    
    private var orderBookData: OrderBookData?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
//        configureDataSource()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        guard let data = orderBookData else {return }
//        reloadData(with: data.asks, for: .ask)
//        reloadData(with: data.bids, for: .bid)
        
//        self.contentView.tableView.scrollToCenter()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.contentView.tableView.scrollToCenter()
    }
    
    func ordeBookData(_ data: OrderBookData) {
//        self.orderBookData = data
    }
    
    private func configureDataSource() {
        dataSource = DataSource(
            tableView: contentView.tableView,
            cellProvider: { (tableView, indexPath, searchResult) -> UITableViewCell? in
                let section = Section(rawValue: indexPath.section)
                switch section {
                case .ask:
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: OrderBookAskTableViewCell.identifier,
                        for: indexPath
                    ) as? OrderBookAskTableViewCell
                    else { return nil }
                    cell.configure(by: searchResult, fluctuation: 100)
                    return cell
                    
                case .bid:
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: OrderBookBidTableViewCell.identifier,
                        for: indexPath
                    ) as? OrderBookBidTableViewCell
                    else { return nil }
                    cell.configure(by: searchResult, fluctuation: 100)
                    return cell
                default:
                    return UITableViewCell() // Here is handling the unmapped case that should not happen
                }
            }
        )
    }
    
    func updateOrderBookData(with bids: [OrderBook], asks: [OrderBook]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.bid, .ask])
        snapshot.appendItems(bids, toSection: .bid)
        snapshot.appendItems(asks, toSection: .ask)
        dataSource?.apply(snapshot, animatingDifferences: true, completion: {
            
        })
        dataSource?.defaultRowAnimation = .middle
    }
}
