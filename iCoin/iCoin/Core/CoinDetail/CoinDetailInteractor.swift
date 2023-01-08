//
//  CoinDetailInteractor.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/07.
//

import ModernRIBs

protocol CoinDetailRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CoinDetailPresentable: Presentable {
    var listener: CoinDetailPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol CoinDetailListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func coinDetailDidTapBackButton()
}

protocol CoinDetailInteractorDependency {
    
}

final class CoinDetailInteractor: PresentableInteractor<CoinDetailPresentable>, CoinDetailInteractable, CoinDetailPresentableListener {

    weak var router: CoinDetailRouting?
    weak var listener: CoinDetailListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: CoinDetailPresentable,
        dependency: CoinDetailInteractorDependency
    ) {
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
    
    func didTapBackButton() {
        listener?.coinDetailDidTapBackButton()
    }
}