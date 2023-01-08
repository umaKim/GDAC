//
//  CommentTableViewCell.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/09.
//

import UIKit.UITableViewCell

final class CommentTableViewCell: UITableViewCell {
    
    static let identifier = "CommentTableViewCell"
    static let prefferedHeight: CGFloat = 200
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let writerIdLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var optionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.addTarget(self, action: #selector(optionButtonDidTap), for: .touchUpInside)
        button.tintColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let cellSeparator: UIView = {
        let uv = UIView()
        uv.alpha = 0.5
        uv.backgroundColor = .systemGray
        uv.translatesAutoresizingMaskIntoConstraints = false
        return uv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    func configure(with data: PostContent) {
        writerIdLabel.text = data.id
        titleLabel.text = data.title
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        
        dateLabel.text = formatter.string(from: data.date, to: now)
        bodyLabel.text = data.body
    }
    
    @objc
    private func optionButtonDidTap() {
        print("Tapped")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Set up UI
extension CommentTableViewCell {
    private func setupUI() {
        titleLabel.text = "Title"
        writerIdLabel.text = "Id"
        dateLabel.text = "2021/08/11/13:50"
        bodyLabel.text = "Body"
        
        let userInfoStackView = UIStackView(arrangedSubviews: [writerIdLabel, dateLabel])
        userInfoStackView.axis = .horizontal
        userInfoStackView.alignment = .leading
        userInfoStackView.distribution = .equalSpacing
        userInfoStackView.spacing = 12
        userInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubviews(titleLabel, optionButton, userInfoStackView, bodyLabel, cellSeparator)
        
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            optionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            optionButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            userInfoStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            userInfoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            userInfoStackView.heightAnchor.constraint(equalToConstant: 30),
            
            bodyLabel.topAnchor.constraint(equalTo: userInfoStackView.bottomAnchor, constant: 10),
            bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bodyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            cellSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            cellSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            cellSeparator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cellSeparator.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
}
