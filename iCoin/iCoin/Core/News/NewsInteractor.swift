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
    func update(with stories: [NewsStory])
}

protocol NewsListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func openNews(of url: String)
}

final class NewsInteractor: PresentableInteractor<NewsPresentable>, NewsInteractable, NewsPresentableListener {
   
    weak var router: NewsRouting?
    weak var listener: NewsListener?
    
    private(set) lazy var stories = [NewsStory]()

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: NewsPresentable) {
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
    
    private func fetchNews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            for index in 0..<20 {
                self.stories.append(.init(category: "",
                                     datetime: 0,
                                     headline: "",
                                     image: "",
                                     related: "",
                                     source: "",
                                     summary: "",
                                     url: "\(index)"))
            }
            self.presenter.update(with: self.stories)
        }
    }
    
    func didTap(indexPath: IndexPath) {
        listener?.openNews(of: stories[indexPath.row].url)
    }
}
