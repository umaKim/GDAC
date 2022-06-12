//
//  MainViewController.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import SafariServices
import FloatingPanel
import ModernRIBs
import Combine
import UIKit

protocol MainPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func edittingButtonDidTap()
    func searchButtonDidTap()
}

final class MainViewController: UIViewController, MainPresentable, MainViewControllable {
    
    func openNews(of url: String) {
        guard let url = URL(string: url) else {return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    private var watchListView: ViewControllable?
    private var opinionsView: ViewControllable?
    private var newsView: ViewControllable?
    
    weak var listener: MainPresentableListener?
    
    private let contentView = MainView()
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func loadView() {
        super.loadView()
        
        view = contentView
        
        contentView.collectionView.dataSource   = self
        contentView.collectionView.delegate     = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationView()
        setupFloatingPanel()
        
        bind()
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink { action in
                switch action {
                case .didTapEditting:
                    self.listener?.edittingButtonDidTap()
                case .searchButtonDidTap:
                    self.listener?.searchButtonDidTap()
                case .writingOpinionDidTap:
                    print("writingOpinionDidTap")
                }
            }
            .store(in: &cancellables)
    }
}

extension MainViewController: FloatingPanelControllerDelegate {
    private func setupFloatingPanel() {
        let panel = FloatingPanelController(delegate: self)
        panel.set(contentViewController: newsView?.uiviewController)
        panel.addPanel(toParent: self)
        guard let newsVC = newsView?.uiviewController as? NewsViewController else {return }
        panel.track(scrollView: newsVC.tableView)
        
        let appearance = SurfaceAppearance()
        appearance.backgroundColor = .systemBackground
        appearance.cornerRadius = 10
        panel.surfaceView.appearance = appearance
    }
}

//MARK: - Set up Views
extension MainViewController {
    private func setUpNavigationView() {
        let titleView = UIView(frame: CGRect(x: 0, y: 0,
                                             width: navigationController?.navigationBar.width ?? 0,
                                             height: navigationController?.navigationBar.height ?? 25))
        let label   = UILabel(frame: CGRect(x: 10, y: 0, width: titleView.width, height: titleView.height))
        label.text  = "iCrypto"
        label.font  = .systemFont(ofSize: 30, weight: .medium)
        label.textColor = .white
        titleView.addSubview(label)
        navigationItem.titleView = titleView
        
        navigationItem.rightBarButtonItems = [contentView.writeOpinionsButton,
                                              contentView.searchButton]
        
        navigationController?.navigationBar.backgroundColor = .black
    }
    
    func setWatchlist(_ view: ViewControllable) {
        watchListView = view
    }
    
    func setOpinion(_ view: ViewControllable) {
        opinionsView = view
    }
    
    func setNews(_ view: ViewControllable) {
        newsView = view
    }
}

//MARK: - ScrollView
extension MainViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentView.menuTabBar.scrollIndicator(to: scrollView.contentOffset)
    }
    
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: WatchlistCell.identifier,
                    for: indexPath) as? WatchlistCell,
                let watchListView = watchListView
            else { return UICollectionViewCell() }
            
            cell.configure(with: watchListView.uiviewController.view)
            return cell
            
        case 1:
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: OpinionsCell.identifier,
                    for: indexPath) as? OpinionsCell,
                let opinionsView = opinionsView
            else { return UICollectionViewCell() }
            
            cell.configure(with: opinionsView.uiviewController.view)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width, height: collectionView.frame.height)
    }
}

