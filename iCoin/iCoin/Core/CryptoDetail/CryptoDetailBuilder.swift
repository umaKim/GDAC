//
//  CryptoDetailBuilder.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/12.
//

import ModernRIBs

protocol CryptoDetailDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class CryptoDetailComponent: Component<CryptoDetailDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol CryptoDetailBuildable: Buildable {
    func build(withListener listener: CryptoDetailListener) -> CryptoDetailRouting
}

final class CryptoDetailBuilder: Builder<CryptoDetailDependency>, CryptoDetailBuildable {

    override init(dependency: CryptoDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CryptoDetailListener) -> CryptoDetailRouting {
        let component = CryptoDetailComponent(dependency: dependency)
        let viewController = CryptoDetailViewController()
        let interactor = CryptoDetailInteractor(presenter: viewController)
        interactor.listener = listener
        return CryptoDetailRouter(interactor: interactor, viewController: viewController)
    }
}
