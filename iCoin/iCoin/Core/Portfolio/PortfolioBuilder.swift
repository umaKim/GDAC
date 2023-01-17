//
//  PortfolioBuilder.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/14.
//
import Combine
import ModernRIBs

protocol PortfolioDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class PortfolioComponent: Component<PortfolioDependency>,
                                WatchlistDependency,
                                PortfolioInteractorDependency,
                                CoinDetailDependency {
                                    
    let watchlistRepository: WatchlistRepository
    
    lazy var lifeCycleDidChangePublisher = lifeCycleDidChangeSubject.eraseToAnyPublisher()
    var lifeCycleDidChangeSubject = PassthroughSubject<MainViewLifeCycle, Never>()
    
    lazy var symbol: AnyPublisher<SymbolResult, Never> = symbolSubject.eraseToAnyPublisher()
    var symbolSubject: PassthroughSubject<SymbolResult, Never> = PassthroughSubject<SymbolResult, Never>()

    init(
        dependency: PortfolioDependency,
        watchlistRepository: WatchlistRepository
    ) {
        self.watchlistRepository = watchlistRepository
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol PortfolioBuildable: Buildable {
    func build(withListener listener: PortfolioListener) -> PortfolioRouting
}

final class PortfolioBuilder: Builder<PortfolioDependency>, PortfolioBuildable {

    override init(dependency: PortfolioDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: PortfolioListener) -> PortfolioRouting {
        let component = PortfolioComponent(
            dependency: dependency,
            myWatchlistRepository: WebsocketRepositoryImp(
                websocket: StarScreamWebSocket(),
                network: NetworkManager()
            )
        )
        let viewController = PortfolioViewController()
        let interactor = PortfolioInteractor(
            presenter: viewController,
            dependency: component
        )
        
        interactor.listener = listener
        
        let watchlist = WatchlistBuilder(dependency: component)
        let coinDetail = CoinDetailBuilder(dependency: component)
        
        return PortfolioRouter(
            interactor: interactor,
            viewController: viewController,
            watchlist: watchlist,
            coinDetail: coinDetail
        )
    }
}
