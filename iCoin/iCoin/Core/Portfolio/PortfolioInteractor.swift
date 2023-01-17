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
    var symbolSubject: PassthroughSubject<SymbolResult, Never> { get }
    var lifeCycleDidChangeSubject: PassthroughSubject<MainViewLifeCycle, Never> { get }
}

final class PortfolioInteractor: PresentableInteractor<PortfolioPresentable>, PortfolioInteractable, PortfolioPresentableListener {
    
    weak var router: PortfolioRouting?
    weak var listener: PortfolioListener?
    
    private let dependency: PortfolioInteractorDependency

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
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
    
    func viewDidAppear() {
        dependency.lifeCycleDidChangeSubject.send(.viewDidAppear)
    }
    
    func viewDidDisappear() {
        dependency.lifeCycleDidChangeSubject.send(.viewDidDisappear)
    }
    
    func watchlistDidTap(_ symbol: SymbolResult) {
        router?.attachCoinDetail()
        dependency.symbolSubject.send(symbol)
    }
    
    func coinDetailDidTapBackButton() {
        router?.detachCoinDetail()
    }
}
