//
//  SearchCell.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/12.
//

import UIKit.UITableViewCell

final class SearchCell: UITableViewCell {
    static let identifier = "SearchCell"
    static let prefferedHeight: CGFloat = 70
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
