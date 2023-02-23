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
    func searchButtonDidTap()
    func writingOpinionButtonDidTap()
    
    func viewWillAppear()
    func viewWillDisappear()
}

final class MainViewController: UIViewController, MainPresentable, MainViewControllable {
    private var cellableDataSource = CellableViewControllerDatasource()
    private var newsView: ViewControllable?
    weak var listener: MainPresentableListener?
    private let contentView = MainView()
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
        cellableDataSource.view = view
        contentView.collectionView.dataSource   = cellableDataSource
        contentView.collectionView.delegate     = cellableDataSource
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listener?.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener?.viewWillDisappear()
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return }
                switch action {
                case .searchButtonDidTap:
                    self.listener?.searchButtonDidTap()
                case .writingOpinionDidTap:
                    self.listener?.writingOpinionButtonDidTap()
                }
            }
            .store(in: &cancellables)
        
        cellableDataSource
            .contentsOffsetPublisher
            .sink {[weak self] contentsOffset in
                self?.contentView
                    .menuTabBar
                    .scrollIndicator(to: contentsOffset)
            }
            .store(in: &cancellables)
    }
    
    func openNews(of url: String) {
        guard let url = URL(string: url) else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
}

// MARK: - FloatingPanelControllerDelegate
extension MainViewController: FloatingPanelControllerDelegate {
    private func setupFloatingPanel() {
        let panel = FloatingPanelController(delegate: self)
        panel.set(contentViewController: newsView?.uiviewController)
        panel.addPanel(toParent: self)
        guard let newsVC = newsView?.uiviewController as? NewsViewController else { return }
        panel.track(scrollView: newsVC.tableView)
        
        let appearance = SurfaceAppearance()
        appearance.backgroundColor = .systemBackground
        appearance.cornerRadius = 10
        panel.surfaceView.appearance = appearance
    }
}

//MARK: - Set up Views
extension MainViewController: TabBarItemSettable {
    private func setupViews() {
        setUpTabBarItem()
        setUpNavigationView()
        setupFloatingPanel()
    }
    
    private func setUpTabBarItem() {
        setupTabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
    }
    
    private func setUpNavigationView() {
        let logoImage = UIImage.init(named: "gdacLogo")
        let logoImageView = UIImageView.init(image: logoImage)
        let imageItem = UIBarButtonItem.init(customView: logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant:  navigationController?.navigationBar.height ?? 25)
        ])
        navigationItem.leftBarButtonItems =  [imageItem]
        navigationItem.rightBarButtonItems = [
            contentView.writeOpinionsButton,
            contentView.searchButton
        ]
    }
    
    func setWatchlist(_ view: ViewControllable) {
        cellableDataSource.appendCellableView(view)
    }
    
    func setOpinion(_ view: ViewControllable) {
        cellableDataSource.appendCellableView(view)
    }
    
    func setNews(_ view: ViewControllable) {
        newsView = view
    }
}
