//
//  String+Ext.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/18.
//

import UIKit

extension String {
    func downloaded(completion: @escaping (UIImage) -> Void) {
        guard let url = URL(string: self) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() {
                completion(image)
            }
        }.resume()
    }
}

extension String {
    var toDollarDecimal: String? {
        let price = Decimal(string: self)
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 5
        
        return formatter.string(for: price)
    }
    
    var toPercentDecimal: String? {
        let price = Decimal(string: self)
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        return formatter.string(for: price)
    }
}

extension String {
    private var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            let string = try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
            return string
        } catch {
            return nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

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
