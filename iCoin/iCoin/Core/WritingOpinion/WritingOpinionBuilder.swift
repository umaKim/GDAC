//
//  WritingOpinionBuilder.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/16.
//

import ModernRIBs

protocol WritingOpinionDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class WritingOpinionComponent: Component<WritingOpinionDependency>, WritingOpinionInteractorDependency {
    
    let writingOpinionRepository: WritingOpinionRepository
    
    init(
        dependency: WritingOpinionDependency,
        writingOpinionRepository: WritingOpinionRepository
    ) {
        self.writingOpinionRepository = writingOpinionRepository
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol WritingOpinionBuildable: Buildable {
    func build(withListener listener: WritingOpinionListener, symbol: String) -> WritingOpinionRouting
}

final class WritingOpinionBuilder: Builder<WritingOpinionDependency>, WritingOpinionBuildable {
    
    override init(dependency: WritingOpinionDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: WritingOpinionListener, symbol: String) -> WritingOpinionRouting {
        let component = WritingOpinionComponent(
            dependency: dependency,
            writingOpinionRepository:
                WritingOpinionRepositoryImp(
                    firebase: FirebaseManager()
                )
        )
        let viewController = WritingOpinionViewController()
        let interactor = WritingOpinionInteractor(
            presenter: viewController,
            dependency: component,
            symbol: symbol
        )
        interactor.listener = listener
        return WritingOpinionRouter(interactor: interactor, viewController: viewController)
    }
}
