//
//  MainInteractor.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import ModernRIBs
import Combine

protocol MainRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func attachWatchlist()
    func attachOpinion()
    func attachNews()
}

protocol MainPresentable: Presentable {
    var listener: MainPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func openNews(of url: String)
}

protocol MainListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol MainInteractorDependency {
    var watchlistRepository: WatchlistRepository { get }
    var edittingButtonDidTapSubject: PassthroughSubject<Bool, Never> { get }
}

final class MainInteractor: PresentableInteractor<MainPresentable>, MainInteractable, MainPresentableListener {
    func edittingButtonDidTap() {
        dependency.edittingButtonDidTapSubject.send(true)
    }
    
    weak var router: MainRouting?
    weak var listener: MainListener?

    private let dependency: MainInteractorDependency
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: MainPresentable,
        dependency: MainInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
        
        
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        router?.attachWatchlist()
        router?.attachOpinion()
        router?.attachNews()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func openNews(of url: String) {
        presenter.openNews(of: url)
    }
}
