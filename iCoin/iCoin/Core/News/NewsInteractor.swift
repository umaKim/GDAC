//
//  NewsInteractor.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import ModernRIBs
import UIKit
import Combine

protocol NewsRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol NewsPresentable: Presentable {
    var listener: NewsPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func update(with stories: [NewsData])
}

protocol NewsListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func openNews(of url: String)
}

protocol NewsInteractorDependency {
    var newsRepository: NewsRepository { get }
}

final class NewsInteractor: PresentableInteractor<NewsPresentable>, NewsInteractable, NewsPresentableListener {
    
    weak var router: NewsRouting?
    weak var listener: NewsListener?
    
    private var stories = [NewsData]()
    
    private let dependency: NewsInteractorDependency
    
    private var cancellables: Set<AnyCancellable>
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: NewsPresentable,
        dependency: NewsInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        fetchNews()
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    
    func didTap(indexPath: IndexPath) {
        listener?.openNews(of: stories[indexPath.row].url)
    }
}

// MARK: - Network
extension NewsInteractor {
    private func fetchNews() {
        dependency
            .newsRepository
            .fetchNews(of: "")
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: {[weak self] response in
                self?.stories = response.Data
                self?.presenter.update(with: response.Data)
            }
            .store(in: &cancellables)
    }
}
