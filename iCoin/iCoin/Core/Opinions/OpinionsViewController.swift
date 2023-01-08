//
//  OpinionsViewController.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import ModernRIBs
import UIKit

protocol OpinionsPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class OpinionsViewController: UIViewController, OpinionsViewControllable {
   
    private var models: [PostContent] = []

    private typealias DataSource = UITableViewDiffableDataSource<Section, PostContent>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, PostContent>
    enum Section { case main }
    
    weak var listener: OpinionsPresentableListener?
    
    private var dataSource: DataSource?
    
    private let contentView = OpinionsView()
    
    override func loadView() {
        super.loadView()
        view = contentView
        
        configureTableViewDataSource()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData(with: self.models, animation: .fade)
    }
}

// MARK: - OpinionsPresentable
extension OpinionsViewController: OpinionsPresentable {
    func opinions(with data: [PostContent]) {
        self.models = data
    }
    
    func reloadData(
        with data: [PostContent],
        animation: UITableView.RowAnimation
    ) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        dataSource?.apply(snapshot, animatingDifferences: true)
        dataSource?.defaultRowAnimation = animation
    }
}

//MARK: - UITableViewDataSource
extension OpinionsViewController {
    private func configureTableViewDataSource() {
        contentView.tableView.delegate = self
        dataSource = .init(
            tableView: contentView.tableView,
            cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
                guard
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: CommentTableViewCell.identifier,
                        for: indexPath
                    ) as? CommentTableViewCell
                else { return nil }
                cell.configure(with: item)
                return cell
            })
    }
}

// MARK: - UITableViewDelegate
extension OpinionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
