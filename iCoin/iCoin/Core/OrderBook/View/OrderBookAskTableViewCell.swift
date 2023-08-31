//
//  OrderBookAskTableViewCell.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/26.
//

import UIKit

final class OrderBookAskTableViewCell: UITableViewCell {
    //MARK: Properties
    static let identifier = String(describing: OrderBookAskTableViewCell.self)
    
    private let orderInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    private let priceStackView: UIStackView =  {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fill
        return stackView
    }()
    private let quantityStackView: UIStackView =  {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let emptyView = UIView()
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textAlignment = .right
        return label
    }()
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()
    private let fluctuatedRateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textAlignment = .right
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildHierachy()
        laysOutConstraints()
        paintBackground()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(by askInformation: OrderBook, fluctuation: Double?) {
        priceLabel.text = askInformation.price
        quantityLabel.text = askInformation.quantity
        fluctuatedRateLabel.text = format(fluctuation: fluctuation)
        paintLabels(fluctuation: fluctuation)
    }
}

//MARK: - SetUp UI
extension OrderBookAskTableViewCell {
    private func buildHierachy() {
        contentView.addSubview(orderInformationStackView)
        
        orderInformationStackView.addArrangedSubview(quantityStackView)
        orderInformationStackView.addArrangedSubview(priceStackView)
        orderInformationStackView.addArrangedSubview(emptyView)
        
        quantityStackView.addArrangedSubview(quantityLabel)
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(fluctuatedRateLabel)
    }
    
    private func laysOutConstraints() {
        let margin = 5.0
        let insets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        NSLayoutConstraint.activate([
            orderInformationStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            orderInformationStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            orderInformationStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            orderInformationStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            quantityStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.29),
            emptyView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.29)
        ])
        
        quantityStackView.isLayoutMarginsRelativeArrangement = true
        quantityStackView.layoutMargins = insets
        
        priceStackView.isLayoutMarginsRelativeArrangement = true
        priceStackView.layoutMargins = insets
    }
    
    private func paintBackground() {
        let blueColor = UIColor(red: 0.6, green: 0.8, blue: 1, alpha: 0.5)
        
        quantityStackView.backgroundColor = blueColor
        priceStackView.backgroundColor = blueColor
    }
    
    private func paintLabels(fluctuation: Double?) {
        priceLabel.textColor = .label
        fluctuatedRateLabel.textColor = .label
        
        guard let fluctuation = fluctuation else {
            return
        }
        
        if fluctuation < 1 {
            priceLabel.textColor = .systemBlue
            fluctuatedRateLabel.textColor = .systemBlue
        } else if fluctuation > 1 {
            priceLabel.textColor = .systemRed
            fluctuatedRateLabel.textColor = .systemRed
        }
    }
    
    private func format(fluctuation: Double?) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.numberStyle = .percent
        
        guard let fluctuation = fluctuation, let formattedFluctuation = numberFormatter.string(from: NSNumber(value: fluctuation - 1)) else {
            return ""
        }
        
        return formattedFluctuation
    }
}
