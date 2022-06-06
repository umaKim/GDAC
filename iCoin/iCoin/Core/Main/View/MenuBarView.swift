//
//  MenuBarView.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import CombineCocoa
import Combine
import UIKit.UIView

enum MenuTabBarButtonType: Int {
    case myList = 0
    case opinions = 1
}

enum MenuBarButtonAction {
    case didTapMyList
    case didTapOpinions
    case didTapEditting
}

final class MenuBarView: UIView {
    //MARK: - UI Objects
    private let myListButton: MenuBarButton = MenuBarButton(title: "My List")
    private let opinionsButton: MenuBarButton = MenuBarButton(title: "Opinions")
    private let settingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    //MARK: - Combine
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<MenuBarButtonAction, Never>()
    private var cancellable: Set<AnyCancellable>
    
    //MARK: - Init
    override init(frame: CGRect) {
        self.cancellable = .init()
        super.init(frame: .zero)
        
        bind()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Bind
extension MenuBarView {
    private func bind() {
        myListButton
            .tapPublisher
            .sink {[weak self] _ in
                self?.actionSubject.send(.didTapMyList)
            }
            .store(in: &cancellable)
        
        opinionsButton
            .tapPublisher
            .sink {[weak self] _ in
                self?.actionSubject.send(.didTapOpinions)
            }
            .store(in: &cancellable)
        
        settingButton
            .tapPublisher
            .sink { [weak self] _ in
                self?.actionSubject.send(.didTapEditting)
            }
            .store(in: &cancellable)
    }
}

//MARK: - Setup UI
extension MenuBarView {
    private func setupUI() {
        setAlpha(for: myListButton)
        
        let horizontalPadding: CGFloat = 16
        let buttonSpace: CGFloat = 36
        
        addSubviews(myListButton, opinionsButton, settingButton)
//        addSubviews(settingButton)
        
        NSLayoutConstraint.activate([
            myListButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            myListButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),

            opinionsButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            opinionsButton.leadingAnchor.constraint(equalTo: myListButton.trailingAnchor, constant: buttonSpace),
            
            settingButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            settingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding)
        ])
    }
}

//MARK: - Button Actions
extension MenuBarView {
    func selectItem(at index: Int) {
        animateIndicator(to: index)
    }
    
    func scrollIndicator(to contentOffset: CGPoint) {
        let buttons = [myListButton, opinionsButton]
        let index = Int(contentOffset.x / frame.width)
        setAlpha(for: buttons[index])
    }
    
    private func setAlpha(for button: UIButton) {
        self.myListButton.alpha = 0.5
        self.opinionsButton.alpha = 0.5
        button.alpha = 1.0
    }
    
    private func animateIndicator(to index: Int) {
        
        var button: UIButton
        
        switch index {
        case 0:
            button = myListButton
            break
        case 1:
            button = opinionsButton
            break
        default:
            button = myListButton
            break
        }
        
        setAlpha(for: button)
    }
}
