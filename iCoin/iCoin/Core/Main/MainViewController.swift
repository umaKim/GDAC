//
//  MainViewController.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import ModernRIBs
import UIKit

protocol MainPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class MainViewController: UIViewController, MainPresentable, MainViewControllable {
   
    private var watchListView: UIView?
    private var opinionsView: UIView?
    private var newsView: UIView?
    
    weak var listener: MainPresentableListener?
    
    private let contentView = MainView()
    
    override func loadView() {
        super.loadView()
        
        view = contentView
        
        contentView.collectionView.dataSource   = self
        contentView.collectionView.delegate     = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationView()
    }
    
    func setViews(
        watchlist: ViewControllable,
        opinions: ViewControllable,
        news: ViewControllable
    ) {
        watchListView   = watchlist.uiviewController.view
        opinionsView    = opinions.uiviewController.view
        newsView        = news.uiviewController.view
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentView.menuTabBar.scrollIndicator(to: scrollView.contentOffset)
    }
    
    private func setUpNavigationView() {
        let titleView = UIView(frame: CGRect(x: 0, y: 0,
                                             width: navigationController?.navigationBar.width ?? 0,
                                             height: navigationController?.navigationBar.height ?? 25))
        let label   = UILabel(frame: CGRect(x: 10, y: 0, width: titleView.width, height: titleView.height))
        label.text  = "iFinance"
        label.font  = .systemFont(ofSize: 30, weight: .medium)
        label.textColor = .white
        titleView.addSubview(label)
        navigationItem.titleView = titleView
        
        navigationItem.rightBarButtonItems = [contentView.writeOpinionsButton,
                                              contentView.searchButton]
        
        navigationController?.navigationBar.backgroundColor = .black
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
                for: indexPath) as? WatchlistCell
//                  let watchListView = watchListView
            else { return UICollectionViewCell() }
            
//            cell.configure(with: watchListView)
            return cell
            
        case 1:
            guard
                let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: OpinionsCell.identifier,
                for: indexPath) as? OpinionsCell
//                let opinionsView = opinionsView
            else { return UICollectionViewCell() }
            
//            cell.configure(with: opinionsView)
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

