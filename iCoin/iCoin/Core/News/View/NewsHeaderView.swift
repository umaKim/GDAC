//
//  NewsHeaderView.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/07.
//

import CombineCocoa
import Combine
import SDWebImage
import UIKit.UITableViewHeaderFooterView

enum NewsHeaderViewAction {
    case didTapToAdd
}

/// TableView header for news
final class NewsHeaderView: UITableViewHeaderFooterView {
    /// Header identifier
    static let identifier = "NewsHeaderView"
    
    /// Ideal height of header
    static let preferredHeight: CGFloat = 50
    
    //MARK: - Combine
    private var cancellables: Set<AnyCancellable>
    
    /// ViewModel for header view
    struct ViewModel {
        let title: String
    }
    
    // MARK: - Private
    private let label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    override init(reuseIdentifier: String?) {
        self.cancellables = .init()
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    private func setupUI() {
        addSubviews(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(
            x: 14,
            y: 0,
            width: contentView.width - 28,
            height: contentView.height
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }

    /// Configure view
    /// - Parameter viewModel: View ViewModel
    public func configure(with viewModel: ViewModel) {
        label.text = viewModel.title
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
