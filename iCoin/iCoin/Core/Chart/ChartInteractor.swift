//
//  ChartInteractor.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/20.
//

import ModernRIBs

protocol ChartRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ChartPresentable: Presentable {
    var listener: ChartPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ChartListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ChartInteractor: PresentableInteractor<ChartPresentable>, ChartInteractable, ChartPresentableListener {

    weak var router: ChartRouting?
    weak var listener: ChartListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: ChartPresentable) {
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
