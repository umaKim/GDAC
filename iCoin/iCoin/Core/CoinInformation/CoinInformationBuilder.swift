//
//  CoinInformationBuilder.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/20.
//

import ModernRIBs

protocol CoinInformationDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class CoinInformationComponent: Component<CoinInformationDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol CoinInformationBuildable: Buildable {
    func build(withListener listener: CoinInformationListener) -> CoinInformationRouting
}

final class CoinInformationBuilder: Builder<CoinInformationDependency>, CoinInformationBuildable {

    override init(dependency: CoinInformationDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CoinInformationListener) -> CoinInformationRouting {
        let component = CoinInformationComponent(dependency: dependency)
        let viewController = CoinInformationViewController()
        let interactor = CoinInformationInteractor(presenter: viewController)
        interactor.listener = listener
        return CoinInformationRouter(interactor: interactor, viewController: viewController)
    }
}
