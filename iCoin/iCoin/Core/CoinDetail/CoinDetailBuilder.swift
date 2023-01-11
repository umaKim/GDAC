//
//  CoinDetailBuilder.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/07.
//
import Combine
import ModernRIBs

protocol CoinDetailDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
    
    var symbol: AnyPublisher<SymbolResult, Never> { get }
}

final class CoinDetailComponent: Component<CoinDetailDependency>, CoinDetailInteractorDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    
    var symbol: AnyPublisher<SymbolResult, Never> { dependency.symbol }
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
        let component = CoinDetailComponent(dependency: dependency)
        let viewController = CoinDetailViewController()
        let interactor = CoinDetailInteractor(
            presenter: viewController,
            dependency: component
        )
        interactor.listener = listener
        return CoinDetailRouter(interactor: interactor, viewController: viewController)
    }
}
