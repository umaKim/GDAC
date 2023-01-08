//
//  OpinionsInteractor.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//
import Combine
import FirebaseDatabase
import UIKit.UITableView
import ModernRIBs

protocol OpinionsRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol OpinionsPresentable: Presentable {
    var listener: OpinionsPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func opinions(with data: [PostContent])
    func reloadData(with data: [PostContent], animation: UITableView.RowAnimation)
}

protocol OpinionsListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol OpinionInteractorDependency {
    var firebaseRepository: FirebaseRepository { get }
}

final class OpinionsInteractor: PresentableInteractor<OpinionsPresentable>, OpinionsInteractable, OpinionsPresentableListener {

    weak var router: OpinionsRouting?
    weak var listener: OpinionsListener?
    
    private let dependency: OpinionInteractorDependency

    private(set) var opinions: [PostContent] =  []
    
    private var cancellalbles: Set<AnyCancellable>
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: OpinionsPresentable,
        dependency: OpinionInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellalbles = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        dependency
            .firebaseRepository
            .fetchOpinions()
            .receive(on: RunLoop.main)
            .sink {[weak self] content in
                guard let self = self else { return }
                self.opinions.append(content)
                self.opinions.sort(by: {$0.date > $1.date})
                self.presenter.opinions(with: self.opinions)
            }
            .store(in: &cancellalbles)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
