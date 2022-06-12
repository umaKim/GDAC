//
//  SearchViewController.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/12.
//

import ModernRIBs
import UIKit

protocol SearchPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func didTapBackButton()
    func search(text: String)
    func didTap(_ indexPath: IndexPath)
}

final class SearchViewController: UIViewController, SearchPresentable, SearchViewControllable {

    private typealias DataSource = UITableViewDiffableDataSource<Section, SearchResult>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, SearchResult>
    
    private var dataSource: DataSource?
    
    enum Section { case main }
    
    private let contentView = SearchView()
    
    weak var listener: SearchPresentableListener?
    
    override func loadView() {
        super.loadView()
        
        self.view = contentView
    }
    
    private lazy var searchBar : UISearchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search"
        setupNavigationItem(with: .back, tintColor: .white, target: self, action: #selector(backButtonDidTap))
        
        configureDataSource()
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    @objc
    private func backButtonDidTap() {
        listener?.didTapBackButton()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        listener?.search(text: searchText)
    }
}

// MARK: - UICollectionViewDataSource
extension SearchViewController {
    private func configureDataSource() {
        contentView.tableView.delegate = self
        
        dataSource = DataSource(
            tableView: contentView.tableView,
            cellProvider: { (tableView, indexPath, searchResult) -> UITableViewCell? in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SearchCell.identifier,
                    for: indexPath) as? SearchCell else { return nil }
                cell.textLabel?.text = searchResult.displaySymbol
                cell.detailTextLabel?.text = searchResult.description
                return cell
            })
    }
    
    func reloadData(
        with data: [SearchResult],
        animation: UITableView.RowAnimation
    ) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        dataSource?.apply(snapshot, animatingDifferences: true)
        dataSource?.defaultRowAnimation = animation
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contentView.tableView.deselectRow(at: indexPath, animated: true)
        listener?.didTap(indexPath)
    }
}
