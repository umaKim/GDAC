//
//  SearchBuilder.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/12.
//

import ModernRIBs

protocol SearchDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SearchComponent: Component<SearchDependency>, SearchInteractorDependency {
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    
    let searchRepository: SearchRepository
    
    init (
        dependency: SearchDependency,
        searchRepository: SearchRepository
    ) {
        self.searchRepository = searchRepository
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol SearchBuildable: Buildable {
    func build(withListener listener: SearchListener) -> SearchRouting
}

final class SearchBuilder: Builder<SearchDependency>, SearchBuildable {

    override init(dependency: SearchDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SearchListener) -> SearchRouting {
        let component = SearchComponent(dependency: dependency,
                                        searchRepository: SearchRepositoryImp(network: NetworkManager()))
        let viewController = SearchViewController()
        let interactor = SearchInteractor(presenter: viewController,
                                          dependency: component)
        interactor.listener = listener
        return SearchRouter(interactor: interactor,
                            viewController: viewController)
    }
}
