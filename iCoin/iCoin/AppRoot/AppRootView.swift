////
////  AppRootView.swift
////  iCoin
////
////  Created by 김윤석 on 2022/11/20.
////
//
//import Combine
//import CombineCocoa
//import UIKit.UIView
//
//enum AppRootViewAction {
//    case buttonDidTap
//}
//
//final class AppRootView: UIView {
//    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
//    private let actionSubject = PassthroughSubject<AppRootViewAction, Never>()
//    
//    private var cancellables: Set<AnyCancellable>
//    
//    //MARK: - UI Objects
////    private(set) lazy var menuTabBar = MenuBarView()
//    
//    private(set) lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.minimumLineSpacing = 0
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
////        cv.register(MyListCollectionViewCell.self, forCellWithReuseIdentifier: MyListCollectionViewCell.identifier)
////        cv.register(OpinionsCollectionViewCell.self, forCellWithReuseIdentifier: OpinionsCollectionViewCell.identifier)
//        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//        cv.isPagingEnabled = true
//        cv.showsHorizontalScrollIndicator = false
//        cv.translatesAutoresizingMaskIntoConstraints = false
//        return cv
//    }()
//    
//    override init(frame: CGRect) {
//        self.cancellables = .init()
//        super.init(frame: frame)
//        
//        setupUI()
//        bind()
//    }
//    
//    private func bind() {
////        button
////            .tapPublisher
////            .sink { _ in
////                self.actionSubject.send(.buttonDidTap)
////            }
////            .store(in: &cancellables)
//    }
//    
//    private func setupUI() {
////        searchButton.tintColor        = .white
////        writeOpinionsButton.tintColor = .white
//
//        addSubviews(collectionView)
//        
//        NSLayoutConstraint.activate([
////            menuTabBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
////            menuTabBar.leadingAnchor.constraint(equalTo: leadingAnchor),
////            menuTabBar.trailingAnchor.constraint(equalTo: trailingAnchor),
////            menuTabBar.heightAnchor.constraint(equalToConstant: 50),
//            
//            collectionView.topAnchor.constraint(
//                equalToSystemSpacingBelow: topAnchor,
//                multiplier: 0),
//            collectionView.leadingAnchor.constraint(
//                equalToSystemSpacingAfter: leadingAnchor,
//                multiplier: 0),
//            trailingAnchor.constraint(
//                equalToSystemSpacingAfter: collectionView.trailingAnchor,
//                multiplier: 0),
//            safeAreaLayoutGuide.bottomAnchor.constraint(
//                equalToSystemSpacingBelow: collectionView.bottomAnchor,
//                multiplier: 0)
//        ])
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//// MARK: - Add Subview
//
////extension UIView {
////    /// Adds multiple subviews
////    /// - Parameter views: Collection of subviews
////    func addSubviews(_ views: UIView...) {
////        views.forEach {
////            addSubview($0)
////            $0.translatesAutoresizingMaskIntoConstraints = false
////        }
////    }
////}
