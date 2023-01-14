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
                                MyWatchListDependency,
                                PortfolioInteractorDependency,
                                CoinDetailDependency {
    
    lazy var portfolioViewLifeCycleDidChangePublisher = portfolioViewLifeCycleDidChangeSubject.eraseToAnyPublisher()
    var portfolioViewLifeCycleDidChangeSubject: PassthroughSubject<MainViewLifeCycle, Never> = PassthroughSubject<MainViewLifeCycle, Never>()
    
    lazy var symbol: AnyPublisher<SymbolResult, Never> = symbolSubject.eraseToAnyPublisher()
    var symbolSubject: PassthroughSubject<SymbolResult, Never> = PassthroughSubject<SymbolResult, Never>()

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    let myWatchlistRepository: WebsocketRepository
    
    init(
        dependency: PortfolioDependency,
        myWatchlistRepository: WebsocketRepository
    ) {
        self.myWatchlistRepository = myWatchlistRepository
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
        
        let myWatchList = MyWatchListBuilder(dependency: component)
        let coinDetail = CoinDetailBuilder(dependency: component)
        
        return PortfolioRouter(
            interactor: interactor,
            viewController: viewController,
            myWatchList: myWatchList,
            coinDetail: coinDetail
        )
    }
}
