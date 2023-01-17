//
//  WritingOpinionView.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/16.
//

import UIKit.UIView
import CombineCocoa
import Combine

enum WritingViewAction {
    case saveButtonDidTap(PostContent)
    case dismiss
}

final class WritingView: BaseView {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<WritingViewAction, Never>()
    
    private(set) lazy var dismissButton = UIBarButtonItem(
        image: UIImage(systemName: "xmark"),
        style: .done,
        target: nil,
        action: nil
    )
    
    private lazy var writerIdTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .tertiaryLabel
        textField.layer.cornerRadius = 8
        textField.addLeftPadding()
        textField.placeholder = "ID"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .tertiaryLabel
        textField.layer.cornerRadius = 8
        textField.addLeftPadding()
        textField.placeholder = "Title"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var bodyTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .tertiaryLabel
        textField.layer.cornerRadius = 8
        textField.addLeftPadding()
        textField.placeholder = "Share your idea or opinion"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let bodyTextView = CaptionTextView()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gdacBlue
        button.setTitle("SAVE", for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        bind()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Bind
extension WritingView {
    private func bind() {
        saveButton
            .tapPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                let data = PostContent(
                    id: self.writerIdTextField.text ?? "",
                    title: self.titleTextField.text ?? "",
//                    date: Int(NSDate().timeIntervalSince1970),
                    date: Date(),
                    body: self.bodyTextView.text
                )
                self.actionSubject.send(.saveButtonDidTap(data))
            }
            .store(in: &cancellables)
        
        dismissButton
            .tapPublisher
            .sink {[weak self] _ in
                self?.actionSubject.send(.dismiss)
            }
            .store(in: &cancellables)
    }
}

//MARK: - setup UI
extension WritingView {
    private func setupUI() {
        backgroundColor = .systemBackground
        dismissButton.tintColor = .gdacBlue
        addSubviews(writerIdTextField, titleTextField, bodyTextView, saveButton)
        NSLayoutConstraint.activate([
            writerIdTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            writerIdTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            writerIdTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            writerIdTextField.heightAnchor.constraint(equalToConstant: 40),
            
            titleTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleTextField.topAnchor.constraint(equalTo: writerIdTextField.bottomAnchor, constant: 10),
            titleTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),
            
            bodyTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            bodyTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            bodyTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            bodyTextView.heightAnchor.constraint(equalToConstant: 200),
            
            saveButton.topAnchor.constraint(equalTo: bodyTextView.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            saveButton.widthAnchor.constraint(equalToConstant: frame.width / 4)
        ])
    }
}
