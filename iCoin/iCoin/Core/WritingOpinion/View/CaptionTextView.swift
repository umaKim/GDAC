//
//  CaptionTextView.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/16.
//

import UIKit

final class CaptionTextView: UITextView {
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "  Share your idea here"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Init
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        font = UIFont.systemFont(ofSize: 16)
        
        configurePlaceHolder()
        configureNotificationCenter()
    }
    
    private func configureNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChangeHandler),
            name: UITextView.textDidChangeNotification,
            object: nil
        )
    }
    
    @objc
    private func textDidChangeHandler() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    private func configurePlaceHolder() {
        addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
