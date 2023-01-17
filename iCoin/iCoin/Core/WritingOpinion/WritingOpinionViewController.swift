//
//  WritingOpinionViewController.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/16.
//
import Combine
import ModernRIBs
import UIKit

protocol WritingOpinionPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func dismiss()
    func saveButtonDidTap(_ data: PostContent)
}

final class WritingOpinionViewController: UIViewController, WritingOpinionPresentable, WritingOpinionViewControllable {

    weak var listener: WritingOpinionPresentableListener?
    
    private let contentView = WritingView()
   
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems = [contentView.dismissButton]
        bind()
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else { return }
                switch action {
                case .dismiss:
                    self.listener?.dismiss()
                case .saveButtonDidTap(let opinionData):
                    self.listener?.saveButtonDidTap(opinionData)
                }
            }
            .store(in: &cancellables)
    }
}
