//
//  MyWatchListViewController.swift
//  iCoin
//
//  Created by 김윤석 on 2022/11/20.
//

import Combine
import ModernRIBs
import UIKit

protocol MyWatchListPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    
    func viewDidAppear()
    func viewDidDisappear()
    func didTap()
}

final class MyWatchListViewController: UIViewController, MyWatchListPresentable, MyWatchListViewControllable {

    private typealias DataSource = TableViewDiffableDataSource
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, WatchlistItemModel>
    
    weak var listener: MyWatchListPresentableListener?
    
    private let contentView = MyWatchListView()
    
    private var dataSource: DataSource?
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
        setupTabBarItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        listener?.viewDidAppear()
        print("MyWatchListViewController viewDidAppear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        listener?.viewDidDisappear()
        print("MyWatchListViewController viewDidDisappear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        bind()
    }
    
    private func bind() {
        dataSource?
            .actionPublisher
            .sink(receiveValue: {[weak self] action in
                switch action {
                case .deleteAt(let index):
//                    self?.listener?.removeItem(at: index)
                    break
                }
            })
            .store(in: &cancellables)
    }
    
    func reloadData(
        with data: [WatchlistItemModel],
        animation: UITableView.RowAnimation
    ) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        dataSource?.apply(snapshot, animatingDifferences: true)
        dataSource?.defaultRowAnimation = animation
    }
    
    func isDataEmpty(_ isEmpty: Bool) {
        #warning("show message that this View Empty")
    }
}

// MARK: - TabBarItemSettable
extension MyWatchListViewController: TabBarItemSettable {
    private func setupTabBarItem() {
        setupTabBarItem(
            title: "My List",
            image: UIImage(systemName: "star"),
            selectedImage: UIImage(systemName: "star.fill")
        )
    }
}

// MARK: - Set up Views
extension MyWatchListViewController {
    private func setupViews() {
        setupLogoView()
        configureTableViewDataSource()
    }
    
    private func setupLogoView() {
        let logoImage = UIImage.init(named: "gdacLogo")
        let logoImageView = UIImageView.init(image: logoImage)
        let imageItem = UIBarButtonItem.init(customView: logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant:  navigationController?.navigationBar.height ?? 25)
        ])
        navigationItem.leftBarButtonItems =  [imageItem]
    }
}

//MARK: - UITableViewDataSource
extension MyWatchListViewController {
    private func configureTableViewDataSource() {
        contentView.tableView.delegate = self
        dataSource = .init(
            tableView: contentView.tableView,
            cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
                guard
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: WatchlistItemCell.identifier,
                        for: indexPath
                    ) as? WatchlistItemCell
                else { return nil }
                cell.configure(with: item)
                return cell
            })
    }
}

// MARK: - UITableViewDelegate
extension MyWatchListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WatchlistItemCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        listener?.didTap()
    }
}
