//
//  WatchlistItemCell.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/06.
//

import UIKit.UITableViewCell

/// Table cell for watch list item
final class WatchlistItemCell: UITableViewCell {
    /// Cell id
    static let identifier = "WatchListTableViewCell"
    
    /// Ideal height of cell
    static let preferredHeight: CGFloat = 60

    /// Symbol Label
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .gdacBlue
        return label
    }()
    
    /// Company Label
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    /// Price Label
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .right
        label.layer.cornerRadius = 3
        return label
    }()
    
    /// Price Label
    private let changePercent: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .right
        label.layer.cornerRadius = 3
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        symbolLabel.text = nil
        nameLabel.text = nil
        priceLabel.text = nil
    }
    
    private var model: WatchlistItemModel?
    private var oldPriceKeeper: String = "0"
    
    /// Configure view
    /// - Parameter model: WatchlistItemModel
    public func configure(with model: WatchlistItemModel) {
        self.model = model
        
        let newPrice = Double(model.price) ?? 0
        let oldPrice = Double(oldPriceKeeper) ?? 0
        
        if newPrice != oldPrice {
            let chnageColor: UIColor = oldPrice < newPrice ? .gdacRed : .gdacBlue
            animateLabelBackgroundColor(chnageColor)
        }
        
        let changePercentage = Double(model.changePercentage) ?? 0
        if changePercentage > 0 {
            self.changePercent.textColor = .gdacRed
        } else {
            self.changePercent.textColor = .gdacBlue
        }
        
        symbolLabel.text = model.symbol
        nameLabel.text =  "\(model.symbol)/USD"
        priceLabel.text = "$\(model.price)"
        changePercent.text = "\(model.changePercentage)%"
        oldPriceKeeper = model.price
    }
    
    private func animateLabelBackgroundColor(_ color: UIColor) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear]) { [weak self] in
            self?.priceLabel.layer.backgroundColor = color.cgColor
            self?.priceLabel.textColor = .white
        } completion: {[weak self] _ in
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear]) {
                self?.priceLabel.layer.backgroundColor = UIColor.clear.cgColor
                self?.priceLabel.textColor = .gdacGray
            } completion: { _ in }
        }
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

//MARK: - setup UI
extension WatchlistItemCell {
    private func setupUI() {
        contentView.backgroundColor = .systemBackground
        configureTitleLabels()
        configurePriceLabels()
    }
    
    private func configureTitleLabels() {
        let labelStackView          = UIStackView(arrangedSubviews: [symbolLabel, nameLabel])
        labelStackView.distribution = .equalSpacing
        labelStackView.spacing      = 6
        labelStackView.axis         = .vertical
        contentView.addSubviews(labelStackView)
        NSLayoutConstraint.activate([
            labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            labelStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func configurePriceLabels() {
        let labelStackView          = UIStackView(arrangedSubviews: [priceLabel, changePercent])
        labelStackView.distribution = .fill
        labelStackView.alignment    = .trailing
        labelStackView.spacing      = 6
        labelStackView.axis         = .vertical
        contentView.addSubviews(labelStackView)
        NSLayoutConstraint.activate([
            labelStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            labelStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
