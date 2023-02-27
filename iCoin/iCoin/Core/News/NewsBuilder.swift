//
//  NewsBuilder.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import ModernRIBs

protocol NewsDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
    
//    var newsRepository: NewsRepository { get }
}

final class NewsComponent: Component<NewsDependency>, NewsInteractorDependency {
    let newsRepository: NewsRepository
    
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    
    init(
        dependency: NewsDependency,
        newsRepository: NewsRepository
    ) {
        self.newsRepository = newsRepository
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol NewsBuildable: Buildable {
    func build(withListener listener: NewsListener) -> NewsRouting
}

final class NewsBuilder: Builder<NewsDependency>, NewsBuildable {

    override init(dependency: NewsDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: NewsListener) -> NewsRouting {
        let component = NewsComponent(
            dependency: dependency,
            newsRepository:
                NewsRepositoryImp(
                    network: NetworkManager()
                )
        )
        let viewController = NewsViewController()
        let interactor = NewsInteractor(
            presenter: viewController,
            dependency: component
        )
        interactor.listener = listener
        return NewsRouter(interactor: interactor, viewController: viewController)
    }
}
