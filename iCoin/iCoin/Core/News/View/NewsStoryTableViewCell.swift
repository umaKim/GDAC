//
//  NewsStoryTableViewCell.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/07.
//

import SDWebImage
import UIKit.UITableViewCell

/// News story tableView Cell
final class NewsStoryTableViewCell: UITableViewCell {
    /// Cell id
    static let identfier = "NewsStoryTableViewCell"
    
    /// Ideal height of ceell
    static let preferredHeight: CGFloat = 140
    
    /// Cell viewModel
    struct ViewModel {
        let source: String
        let headline: String
        let dateString: String
        let imageUrl: URL?
        
        init(model: NewsStory) {
            self.source = model.source
            self.headline = model.headline
            self.dateString = .string(from: model.datetime)
            self.imageUrl = URL(string: model.image)
        }
    }
    
    /// Source label
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    /// Headline label
    private let headlineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.numberOfLines = 2
        return label
    }()
    
    /// Date label
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    /// Image for story
    private let storyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .tertiarySystemBackground
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
        backgroundColor = .secondarySystemBackground
        //        addSubviews(sourceLabel, headlineLabel, dateLabel, storyImageView)
        [sourceLabel, headlineLabel, dateLabel, storyImageView]
            .forEach {
                self.addSubview($0)
            }
        
        //        let verticalStackView = UIStackView(arrangedSubviews: [headlineLabel, dateLabel])
        //        verticalStackView.axis = .vertical
        //        verticalStackView.spacing = 3
        //        verticalStackView.alignment = .leading
        //        verticalStackView.distribution = .fill
        //
        //        let horizontalStackView = UIStackView(arrangedSubviews: [verticalStackView, storyImageView])
        //        horizontalStackView.axis = .horizontal
        //        horizontalStackView.spacing = 3
        //        horizontalStackView.alignment = .fill
        //        horizontalStackView.distribution = .fill
        
        //        contentView.addSubviews(storyImageView)
        //
        //        NSLayoutConstraint.activate([
        ////            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
        ////            verticalStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        //            storyImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        //            storyImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
        //            storyImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        //            storyImageView.widthAnchor.constraint(equalToConstant: contentView.height)
        //        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = contentView.height/1.4
        
        storyImageView.frame = CGRect(
            x: contentView.width-imageSize-10,
            y: (contentView.height - imageSize) / 2,
            width: imageSize,
            height: imageSize
        )
        
        // Layout labels
        let availableWidth: CGFloat = contentView.width - separatorInset.left - imageSize - 15
        
        dateLabel.frame = CGRect(
            x: separatorInset.left,
            y: contentView.height - 40,
            width: availableWidth,
            height: 40
        )
        
        sourceLabel.sizeToFit()
        sourceLabel.frame = CGRect(
            x: separatorInset.left,
            y: 4,
            width: availableWidth,
            height: sourceLabel.height
        )
        
        headlineLabel.frame = CGRect(
            x: separatorInset.left,
            y: sourceLabel.bottom + 5,
            width: availableWidth,
            height: contentView.height - sourceLabel.bottom - dateLabel.height - 10
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sourceLabel.text = nil
        headlineLabel.text = nil
        dateLabel.text = nil
        storyImageView.image = nil
    }
    
    /// Configure view
    /// - Parameter viewModel: View ViewModel
    public func configure(with viewModel: ViewModel) {
        headlineLabel.text = viewModel.headline
        sourceLabel.text = viewModel.source
        dateLabel.text = viewModel.dateString
        storyImageView.sd_setImage(with: viewModel.imageUrl, completed: nil)
        // Manually set image
        //         storyImageView.setImage(with: viewModel.imageUrl)
    }
}

/// Represent news story
struct NewsStory: Codable {
    let category: String
    let datetime: TimeInterval
    let headline: String
    let image: String
    let related: String
    let source: String
    let summary: String
    let url: String
}

// MARK: - String

extension String {
    /// Create string from time interval
    /// - Parameter timeInterval: Timeinterval sinec 1970
    /// - Returns: Formatted string
    static func string(from timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        return DateFormatter.prettyDateFormatter.string(from: date)
    }

    /// Percentage formatted string
    /// - Parameter double: Double to format
    /// - Returns: String in percent format
    static func percentage(from double: Double) -> String {
        let formatter = NumberFormatter.percentFormatter
        return formatter.string(from: NSNumber(value: double / 100)) ?? "\(double)"
    }

    /// Format number to string
    /// - Parameter number: Number to format
    /// - Returns: Formatted string
    static func formatted(number: Double) -> String {
        let formatter = NumberFormatter.numberFormatter
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}

// MARK: - DateFormatter

extension DateFormatter {
    static let newsDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    
    static let commentDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()

    static let prettyDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

// NumberFormatter

extension NumberFormatter {
    /// Formatter for percent style
    static let percentFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    /// Formatter for decimal style
    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}
