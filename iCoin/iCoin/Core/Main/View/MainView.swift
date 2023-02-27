//
//  MainView.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import Foundation
import CombineCocoa
import UIKit.UICollectionView
import Combine

enum MainViewAction {
    case searchButtonDidTap
    case writingOpinionDidTap
}

final class MainView: BaseView {
    //MARK: - Combine
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<MainViewAction, Never>()
    
    //MARK: - UI Objects
    private(set) lazy var searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: nil, action: nil)
    private(set) lazy var writeOpinionsButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .done, target: nil, action: nil)
    
    private let chartButton: MenuBarButton = MenuBarButton(title: "Crypto", font: 20)
    private let orderBook: MenuBarButton = MenuBarButton(title: "Opinions", font: 20)
    
    private(set) lazy var menuTabBar = MenuBarView(
        buttons: [chartButton, orderBook],
        alignment: .leading
    )
    private(set) lazy var collectionView = CellableCollectionView()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        bind()
    }
    
    private func scroll(to item: MenuTabBarButtonType) {
        let indexPath = IndexPath(item: item.rawValue, section: 0)
        self.collectionView.scrollToItem(
            at: indexPath,
            at: [],
            animated: true
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainView {
    private func bind() {
        chartButton
            .tapPublisher
            .sink {[weak self] _ in
                self?.scroll(to: .myList)
            }
            .store(in: &cancellables)
        
        orderBook
            .tapPublisher
            .sink {[weak self] _ in
                self?.scroll(to: .orderBook)
            }
            .store(in: &cancellables)
        
        searchButton
            .tapPublisher
            .sink {[weak self] _ in
                self?.actionSubject.send(.searchButtonDidTap)
            }
            .store(in: &cancellables)
        
        writeOpinionsButton
            .tapPublisher
            .sink {[weak self] _ in
                self?.actionSubject.send(.writingOpinionDidTap)
                self?.collectionView.scrollToItem(
                    at: IndexPath(item: 1, section: 0),
                    at: [],
                    animated: true
                )
            }
            .store(in: &cancellables)
    }
}

//MARK: - Set up UI
extension MainView {
    private func setupUI() {
        backgroundColor = .systemBackground
        
        searchButton.tintColor        = .gdacBlue
        writeOpinionsButton.tintColor = .gdacBlue
        
        addSubviews(menuTabBar, collectionView)
        
        NSLayoutConstraint.activate([
            menuTabBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            menuTabBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            menuTabBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            menuTabBar.heightAnchor.constraint(equalToConstant: 50),
            
            collectionView.topAnchor.constraint(
                equalToSystemSpacingBelow: menuTabBar.bottomAnchor,
                multiplier: 0),
            collectionView.leadingAnchor.constraint(
                equalToSystemSpacingAfter: leadingAnchor,
                multiplier: 0),
            trailingAnchor.constraint(
                equalToSystemSpacingAfter: collectionView.trailingAnchor,
                multiplier: 0),
            safeAreaLayoutGuide.bottomAnchor.constraint(
                equalToSystemSpacingBelow: collectionView.bottomAnchor,
                multiplier: 0)
        ])
    }
}
