//
//  PortfolioInteractor.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/14.
//
import Combine
import ModernRIBs

protocol PortfolioRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func attachWatchlist()
    
    func attachCoinDetail()
    func detachCoinDetail()
}

protocol PortfolioPresentable: Presentable {
    var listener: PortfolioPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol PortfolioListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol PortfolioInteractorDependency {
    var symbolSubject: PassthroughSubject<CoinCapAsset, Never> { get }
    var lifeCycleDidChangeSubject: PassthroughSubject<ViewControllerLifeCycle, Never> { get }
}

final class PortfolioInteractor: PresentableInteractor<PortfolioPresentable>, PortfolioInteractable, PortfolioPresentableListener {
    
    weak var router: PortfolioRouting?
    weak var listener: PortfolioListener?
    
    private let dependency: PortfolioInteractorDependency
    
    init(
        presenter: PortfolioPresentable,
        dependency: PortfolioInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        router?.attachWatchlist()
    }

    override func willResignActive() {
        super.willResignActive()
    }
}

// MARK: - Life Cycle
extension PortfolioInteractor {
    func viewDidAppear() {
        dependency.lifeCycleDidChangeSubject.send(.viewWillAppear)
    }
    
    func viewDidDisappear() {
        dependency.lifeCycleDidChangeSubject.send(.viewWillDisappear)
    }
}

// MARK: - Interaction from child RIBs
extension PortfolioInteractor {
    func watchlistDidTap(_ symbol: CoinCapAsset) {
        router?.attachCoinDetail()
        dependency.symbolSubject.send(symbol)
    }
    
    func coinDetailDidTapBackButton() {
        router?.detachCoinDetail()
    }
}
