//
//  ChartBuilder.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/20.
//

import ModernRIBs

protocol ChartDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ChartComponent: Component<ChartDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
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
        let component = ChartComponent(dependency: dependency)
        let viewController = ChartViewController()
        let interactor = ChartInteractor(presenter: viewController)
        interactor.listener = listener
        return ChartRouter(interactor: interactor, viewController: viewController)
    }
}
