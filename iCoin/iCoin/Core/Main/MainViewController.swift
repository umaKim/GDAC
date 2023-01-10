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

enum MainViewLifeCycle {
    case viewDidAppear
    case viewDidDisappear
}

protocol TabBarItemSettable { }
extension TabBarItemSettable where Self: UIViewController {
    func setupTabBarItem(title: String, image: UIImage?, selectedImage: UIImage? = nil) {
        tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
    }
}

protocol MainPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func edittingButtonDidTap()
    func searchButtonDidTap()
    
    func viewDidAppear()
    func viewDidDisappear()
}

final class MainViewController: UIViewController, MainPresentable, MainViewControllable {
    private var cellableViews: [ViewControllable] = []
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
        
        contentView.collectionView.dataSource   = self
        contentView.collectionView.delegate     = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("MainViewController viewDidAppear")
        listener?.viewDidAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("MainViewController viewDidDisappear")
        listener?.viewDidDisappear()
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink { action in
                switch action {
//                case .didTapEditting:
//                    self.listener?.edittingButtonDidTap()
                case .searchButtonDidTap:
                    self.listener?.searchButtonDidTap()
                case .writingOpinionDidTap:
                    print("writingOpinionDidTap")
                }
            }
            .store(in: &cancellables)
    }
    
    func openNews(of url: String) {
        guard let url = URL(string: url) else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
}

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
        cellableViews.append(view)
    }
    
    func setOpinion(_ view: ViewControllable) {
        cellableViews.append(view)
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
        cellableViews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MainViewCell.identifier,
                for: indexPath
            ) as? MainViewCell
        else { return UICollectionViewCell() }
        cell.configure(with: cellableViews[indexPath.item].uiviewController.view)
        return cell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: view.frame.width, height: collectionView.frame.height)
    }
}
