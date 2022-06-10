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
        label.textColor = .white
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 6
        return label
    }()
    
    /// Change Label
    private let changeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white
        label.textAlignment = .right
        label.layer.cornerRadius = 3
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
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
        changeLabel.text = nil
//        miniChartView.reset()
    }
    
    /// Configure view
    /// - Parameter viewModel: View ViewModel
    public func configure(with viewModel: WatchlistItemModel) {
        symbolLabel.text = viewModel.symbol
        nameLabel.text = viewModel.companyName
        priceLabel.text = viewModel.price
        changeLabel.text = viewModel.changePercentage
        changeLabel.backgroundColor = viewModel.changeColor
//        miniChartView.configure(with: viewModel.chartViewModel)
        
        animateLabelBackgroundColor(viewModel.changeColor)
    }
    
    private func animateLabelBackgroundColor(_ color: UIColor) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut]) {
            self.priceLabel.layer.backgroundColor = color.cgColor
            
        } completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut]) {
                self.priceLabel.layer.backgroundColor = UIColor.clear.cgColor
            } completion: { _ in
                
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

//MARK: - setup UI
extension WatchlistItemCell {
    private func setupUI() {
        configureTitleLabels()
        configurePriceLabels()
//        configureChart()
    }
    
    private func configureTitleLabels() {
        let labelStackView = UIStackView(arrangedSubviews: [symbolLabel, nameLabel])
        labelStackView.distribution = .equalSpacing
        labelStackView.spacing = 6
        labelStackView.axis = .vertical
        labelStackView.frame = .init(x: 20,
                                     y:(WatchlistItemCell.preferredHeight - frame.height) / 2,
                                     width: frame.width/2.2,
                                     height: frame.height)

        contentView.addSubview(labelStackView)
    }
    
    private func configurePriceLabels() {
        let labelStackView          = UIStackView(arrangedSubviews: [priceLabel, changeLabel])
        labelStackView.distribution = .fill
        labelStackView.alignment    = .trailing
        labelStackView.spacing      = 6
        labelStackView.axis         = .vertical
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(labelStackView)
        
        NSLayoutConstraint.activate([
            labelStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            labelStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            changeLabel.widthAnchor.constraint(equalToConstant: frame.width / 5)
        ])
    }
}
