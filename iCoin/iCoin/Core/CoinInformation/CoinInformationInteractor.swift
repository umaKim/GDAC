//
//  CoinInformationInteractor.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/20.
//

import ModernRIBs

protocol CoinInformationRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CoinInformationPresentable: Presentable {
    var listener: CoinInformationPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol CoinInformationListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class CoinInformationInteractor: PresentableInteractor<CoinInformationPresentable>, CoinInformationInteractable, CoinInformationPresentableListener {

    weak var router: CoinInformationRouting?
    weak var listener: CoinInformationListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: CoinInformationPresentable) {
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
