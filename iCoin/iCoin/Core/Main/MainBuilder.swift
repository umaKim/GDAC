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
                           SearchDependency,
                           WritingOpinionDependency,
                           CoinDetailDependency {
    
    lazy var symbol: AnyPublisher<CoinCapAsset, Never> = symbolSubject.eraseToAnyPublisher()
    var symbolSubject: PassthroughSubject<CoinCapAsset, Never> = PassthroughSubject<CoinCapAsset, Never>()
    
    lazy var lifeCycleDidChangePublisher: AnyPublisher<MainViewLifeCycle, Never> = lifeCycleDidChangeSubject.eraseToAnyPublisher()
    var lifeCycleDidChangeSubject: PassthroughSubject<MainViewLifeCycle, Never> = PassthroughSubject<MainViewLifeCycle, Never>()
    
    let watchlistRepository: WatchlistRepository
    let newsRepository: NewsRepository
    let opinionRepository: OpinionRepository
    let writingOpinionRepository: WritingOpinionRepository
    
    init(
        dependency: MainDependency,
        watchlistRepository: WatchlistRepository,
        newsRepository: NewsRepository,
        opinionRepository: OpinionRepository,
        writingOpinionRepository: WritingOpinionRepository
    ) {
        self.watchlistRepository = watchlistRepository
        self.newsRepository = newsRepository
        self.opinionRepository = opinionRepository
        self.writingOpinionRepository = writingOpinionRepository
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
            watchlistRepository: WatchlistRepositoryImp(websocket: StarScreamWebSocket()),
            newsRepository: NewsRepositoryImp(network: NetworkManager()),
            opinionRepository: OpinionRepositoryImp(firebase: FirebaseManager()),
            writingOpinionRepository: WritingOpinionRepositoryImp(firebase: FirebaseManager())
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
        let writingOpinion = WritingOpinionBuilder(dependency: component)
        let coinDetail = CoinDetailBuilder(dependency: component)
        
        return MainRouter(
            interactor: interactor,
            viewController: viewController,
            watchListBuildable: watchlist,
            opinionsBuildable: opinions,
            newsBuildable: news,
            searchBuildable: search,
            writingOpinionBuildable: writingOpinion,
            coinDetailBuildable: coinDetail
        )
    }
}
