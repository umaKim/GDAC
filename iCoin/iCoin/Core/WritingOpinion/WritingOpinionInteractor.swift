//
//  WritingOpinionInteractor.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/16.
//

import ModernRIBs

protocol WritingOpinionRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol WritingOpinionPresentable: Presentable {
    var listener: WritingOpinionPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol WritingOpinionListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func writingOpinionDidTapDismiss()
}

protocol WritingOpinionInteractorDependency {
    var writingOpinionRepository: WritingOpinionRepository { get }
}

final class WritingOpinionInteractor: PresentableInteractor<WritingOpinionPresentable>, WritingOpinionInteractable, WritingOpinionPresentableListener {

    weak var router: WritingOpinionRouting?
    weak var listener: WritingOpinionListener?

    private let dependency: WritingOpinionInteractorDependency
    
    private let symbol: String
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: WritingOpinionPresentable,
        dependency: WritingOpinionInteractorDependency,
        symbol: String
    ) {
        self.dependency = dependency
        self.symbol = symbol
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
    
    func dismiss() {
        listener?.writingOpinionDidTapDismiss()
    }
    
    func saveButtonDidTap(_ data: PostContent) {
        dependency.writingOpinionRepository.postOpinion(symbol: symbol, data: data)
        listener?.writingOpinionDidTapDismiss()
    }
}
