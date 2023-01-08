//
//  MyWatchListBuilder.swift
//  iCoin
//
//  Created by 김윤석 on 2022/11/20.
//
import Combine
import ModernRIBs

protocol MyWatchListDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MyWatchListComponent: Component<MyWatchListDependency>,
                                  MyWatchListInteractorDependency,
                                  CoinDetailDependency {
    
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    
    let watchlistRepository: WebsocketRepository
    let persistanceRepository: PersistanceRepository
    
    init(
        dependency: MyWatchListDependency,
        watchlistRepository: WebsocketRepository,
        persistanceRepository: PersistanceRepository
    ) {
        self.watchlistRepository = watchlistRepository
        self.persistanceRepository = persistanceRepository
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol MyWatchListBuildable: Buildable {
    func build(withListener listener: MyWatchListListener) -> MyWatchListRouting
}

final class MyWatchListBuilder: Builder<MyWatchListDependency>, MyWatchListBuildable {

    override init(dependency: MyWatchListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MyWatchListListener) -> MyWatchListRouting {
        let component = MyWatchListComponent(
            dependency: dependency,
            watchlistRepository: WebsocketRepositoryImp(
                websocket: StarScreamWebSocket(),
                network: NetworkManager()
            ),
            persistanceRepository: PersistanceRepositoryImp(PersistanceManager())
        )
        let viewController = MyWatchListViewController()
        let interactor = MyWatchListInteractor(
            presenter: viewController,
            dependency: component
        )
        interactor.listener = listener
        
        let coinDetail = CoinDetailBuilder(dependency: component)
        
        return MyWatchListRouter(
            interactor: interactor,
            viewController: viewController,
            coinDetailBuildable: coinDetail
        )
    }
}
