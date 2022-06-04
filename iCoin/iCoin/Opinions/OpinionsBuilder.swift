//
//  OpinionsBuilder.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import ModernRIBs

protocol OpinionsDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class OpinionsComponent: Component<OpinionsDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol OpinionsBuildable: Buildable {
    func build(withListener listener: OpinionsListener) -> OpinionsRouting
}

final class OpinionsBuilder: Builder<OpinionsDependency>, OpinionsBuildable {

    override init(dependency: OpinionsDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: OpinionsListener) -> OpinionsRouting {
        let component = OpinionsComponent(dependency: dependency)
        let viewController = OpinionsViewController()
        let interactor = OpinionsInteractor(presenter: viewController)
        interactor.listener = listener
        return OpinionsRouter(interactor: interactor, viewController: viewController)
    }
}
