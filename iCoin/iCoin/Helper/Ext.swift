//
//  Ext.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import UIKit

// MARK: - UIView

extension UIView {
    /// Adds multiple subviews
    /// - Parameter views: Collection of subviews
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}

// MARK: - Framing

extension UIView {
    /// Width of view
    var width: CGFloat {
        frame.size.width
    }

    /// Height of view
    var height: CGFloat {
        frame.size.height
    }

    /// Left edge of view
    var left: CGFloat {
        frame.origin.x
    }

    /// Right edge of view
    var right: CGFloat {
        left + width
    }

    /// Top edge of view
    var top: CGFloat {
        frame.origin.y
    }

    /// Bottom edge of view
    var bottom: CGFloat {
        top + height
    }
}

// MARK: - Decodable

extension Decodable {
    static func decode(with decoder: JSONDecoder = JSONDecoder(), from data: Data) throws -> Self? {
        do {
            let newdata = try decoder.decode(Self.self, from: data)
            return newdata
        } catch {
            return nil
        }
    }
}

// MARK: - Color

extension UIColor {
    static let gdacGray = UIColor(red: 90/255, green: 96/255, blue: 111/255, alpha: 1)
    static let gdacLightGray = UIColor(red: 147/255, green: 157/255, blue: 172/255, alpha: 1)
    static let gdacDarkNavy = UIColor(red: 12/255, green: 36/255, blue: 80/255, alpha: 1)
    static let gdacBlue = UIColor(red: 39/255, green: 75/255, blue: 156/255, alpha: 1)
    static let gdacRed = UIColor(red: 208/255, green: 53/255, blue: 61/255, alpha: 1)
}
