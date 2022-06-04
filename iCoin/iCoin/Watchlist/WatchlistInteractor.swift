//
//  WatchlistInteractor.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import ModernRIBs

protocol WatchlistRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol WatchlistPresentable: Presentable {
    var listener: WatchlistPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol WatchlistListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class WatchlistInteractor: PresentableInteractor<WatchlistPresentable>, WatchlistInteractable, WatchlistPresentableListener {

    weak var router: WatchlistRouting?
    weak var listener: WatchlistListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: WatchlistPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
