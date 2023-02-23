//
//  ChartBuilder.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/20.
//

import Combine
import ModernRIBs

protocol ChartDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
    var symbol: AnyPublisher<CoinCapAsset, Never> { get }
}

final class ChartComponent: Component<ChartDependency>,
                            ChartInteractorDependency {
    
    var symbol: AnyPublisher<CoinCapAsset, Never> { dependency.symbol }
    let coinChartRepository: CoinChartRepository
    
    init(
        dependency: ChartDependency,
        coinChartRepository: CoinChartRepository
    ) {
        self.coinChartRepository = coinChartRepository
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol ChartBuildable: Buildable {
    func build(withListener listener: ChartListener) -> ChartRouting
}

final class ChartBuilder: Builder<ChartDependency>, ChartBuildable {

    override init(dependency: ChartDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ChartListener) -> ChartRouting {
        let component = ChartComponent(
            dependency: dependency,
            coinChartRepository:
                CoinChartRepositoryImp(
                    network: NetworkManager()
                )
        )
        let viewController = ChartViewController()
        let interactor = ChartInteractor(
            presenter: viewController,
            dependency: component
        )
        interactor.listener = listener
        return ChartRouter(
            interactor: interactor,
            viewController: viewController
        )
    }
}
