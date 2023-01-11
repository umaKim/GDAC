//
//  SearchBuilder.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/12.
//
import Combine
import ModernRIBs

protocol SearchDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SearchComponent: Component<SearchDependency>, SearchInteractorDependency, CoinDetailDependency {
    
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    lazy var symbol: AnyPublisher<SymbolResult, Never> = symbolSubject.eraseToAnyPublisher()
    var symbolSubject: PassthroughSubject<SymbolResult, Never> = PassthroughSubject<SymbolResult, Never>()
    
    let searchRepository: SymbolsRepository
    
    init (
        dependency: SearchDependency,
        searchRepository: SymbolsRepository
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
        let component = SearchComponent(
            dependency: dependency,
            searchRepository: SymbolsRepositoryImp(network: NetworkManager())
        )
        let viewController = SearchViewController()
        let interactor = SearchInteractor(
            presenter: viewController,
            dependency: component
        )
        interactor.listener = listener
        
        let coinDetail = CoinDetailBuilder(dependency: component)
        
        return SearchRouter(
            interactor: interactor,
            viewController: viewController,
            coinDetail: coinDetail
        )
    }
}
