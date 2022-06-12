//
//  CryptoDetailInteractor.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/12.
//

import ModernRIBs

protocol CryptoDetailRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CryptoDetailPresentable: Presentable {
    var listener: CryptoDetailPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol CryptoDetailListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class CryptoDetailInteractor: PresentableInteractor<CryptoDetailPresentable>, CryptoDetailInteractable, CryptoDetailPresentableListener {

    weak var router: CryptoDetailRouting?
    weak var listener: CryptoDetailListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: CryptoDetailPresentable) {
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
