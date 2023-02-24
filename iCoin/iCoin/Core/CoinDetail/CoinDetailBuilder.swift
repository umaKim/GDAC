//
//  CoinDetailBuilder.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/07.
//
import Combine
import ModernRIBs

protocol CoinDetailDependency: Dependency {
    var symbol: AnyPublisher<CoinCapAsset, Never> { get }
}

final class CoinDetailComponent: Component<CoinDetailDependency>,
                                 CoinDetailInteractorDependency,
                                 ChartDependency,
                                 OrderBookDependency,
                                 CoinInformationDependency {
    
    var symbol: AnyPublisher<CoinCapAsset, Never> { dependency.symbol }
    let coinDetailRepository: CoinDetailRepository
    
    init(
        dependency: CoinDetailDependency,
        coinDetailRepository: CoinDetailRepository
    ) {
        self.coinDetailRepository = coinDetailRepository
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol CoinDetailBuildable: Buildable {
    func build(withListener listener: CoinDetailListener) -> CoinDetailRouting
}

final class CoinDetailBuilder: Builder<CoinDetailDependency>, CoinDetailBuildable {

    override init(dependency: CoinDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CoinDetailListener) -> CoinDetailRouting {
        let component = CoinDetailComponent(
            dependency: dependency,
            coinDetailRepository:
                CoinDetailRepositoryImp(
                    PersistanceManager(),
                    StarScreamWebSocket(),
                    NetworkManager()
                )
        )
        let viewController = CoinDetailViewController()
        let interactor = CoinDetailInteractor(
            presenter: viewController,
            dependency: component
        )
        
        interactor.listener = listener
        
        let chart = ChartBuilder(dependency: component)
        let orderBook = OrderBookBuilder(dependency: component)
        let coinInformation = CoinInformationBuilder(dependency: component)
        
        return CoinDetailRouter(
            interactor: interactor,
            viewController: viewController,
            chartBuilderable: chart,
            orderBookBuilderable: orderBook,
            coinInformationBuilderable: coinInformation
        )
    }
}
