//
//  MainBuilder.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//
import Combine
import UIKit
import ModernRIBs

protocol MainDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MainComponent: Component<MainDependency>,
                           MainInteractorDependency,
                           OpinionInteractorDependency,
                           WatchlistDependency,
                           OpinionsDependency,
                           NewsDependency,
                           SearchDependency {
    
    lazy var edittinButtonDidTap: AnyPublisher<Void, Never> = edittingButtonDidTapSubject.eraseToAnyPublisher()
    var edittingButtonDidTapSubject: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
    
    lazy var mainViewLifeCycleDidChange: AnyPublisher<MainViewLifeCycle, Never> = mainViewLifeCycleDidChangeSubject.eraseToAnyPublisher()
    var mainViewLifeCycleDidChangeSubject: PassthroughSubject<MainViewLifeCycle, Never> = PassthroughSubject<MainViewLifeCycle, Never>()
    
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    
    let watchlistRepository: WebsocketRepository
    let newsRepository: NewsRepository
    let symbolsRepository: SymbolsRepository
    let firebaseRepository: FirebaseRepository
    
    init(
        dependency: MainDependency,
        watchlistRepository: WebsocketRepository,
        newsRepository: NewsRepository,
        symbolsRepository: SymbolsRepository,
        firebaseRepository: FirebaseRepository
    ) {
        self.watchlistRepository = watchlistRepository
        self.newsRepository = newsRepository
        self.symbolsRepository = symbolsRepository
        self.firebaseRepository = firebaseRepository
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol MainBuildable: Buildable {
    func build(withListener listener: MainListener) -> MainRouting
}

final class MainBuilder: Builder<MainDependency>, MainBuildable {
    
    override init(dependency: MainDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: MainListener) -> MainRouting {
        let component = MainComponent(
            dependency: dependency,
            watchlistRepository:
                WebsocketRepositoryImp(
                    websocket: StarScreamWebSocket(),
                    network: NetworkManager()
                ),
            newsRepository: NewsRepositoryImp(network: NetworkManager()),
            symbolsRepository: SymbolsRepositoryImp(network: NetworkManager()),
            firebaseRepository: FirebaseRepositoryImp(firebase: FirebaseManager())
        )
        let viewController = MainViewController()
        let interactor = MainInteractor(
            presenter: viewController,
            dependency: component
        )
        
        interactor.listener = listener
        
        let watchlist = WatchlistBuilder(dependency: component)
        let opinions = OpinionsBuilder(dependency: component)
        let news = NewsBuilder(dependency: component)
        let search = SearchBuilder(dependency: component)
        
        return MainRouter(
            interactor: interactor,
            viewController: viewController,
            watchListBuildable: watchlist,
            opinionsBuildable: opinions,
            newsBuildable: news,
            searchBuildable: search
        )
    }
}
