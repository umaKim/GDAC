//
//  PersistanceManager.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/07.
//

import Foundation

protocol PersistanceService {
    var watchlist: [String] { get }
    func watchlistContains(symbol: String) -> Bool
    func addToWatchlist(symbol: String)
    func removeFromWatchlist(symbol: String)
}

final class PersistanceImpl: PersistanceService {
    /// Reference to user defaults
    private let userDefaults: UserDefaults = .standard
    
    /// Constants
    private struct Constants {
        static let onboardedKey = "hasOnboarded"
        static let watchListKey = "watchlist"
    }
    
    // MARK: - Public
    
    /// Get usr watch list
    public var watchlist: [String] {
        if !hasOnboarded {
            userDefaults.set(true, forKey: Constants.onboardedKey)
            setUpDefaults()
        }
        return userDefaults.stringArray(forKey: Constants.watchListKey) ?? []
    }
    
    /// Check if watch list contains item
    /// - Parameter symbol: Symbol to check
    /// - Returns: Boolean
    public func watchlistContains(symbol: String) -> Bool {
        return watchlist.contains(symbol)
    }
    
    /// Add a symbol to watch list
    /// - Parameters:
    ///   - symbol: Symbol to add
    ///   - companyName: Company name for symbol being added
    public func addToWatchlist(symbol: String) {
        
        if !watchlistContains(symbol: symbol) {
            var current = watchlist
            current.append(symbol)
            userDefaults.set(current, forKey: Constants.watchListKey)
        }
    }
    
    /// Remove item from watchlist
    /// - Parameter symbol: Symbol to remove
    public func removeFromWatchlist(symbol: String) {
        var newList = [String]()
        
        userDefaults.set(nil, forKey: symbol)
        for item in watchlist where item != symbol {
            newList.append(item)
        }
        
        userDefaults.set(newList, forKey: Constants.watchListKey)
    }
    
    // MARK: - Private
    
    /// Check if user has been onboarded
    private var hasOnboarded: Bool {
        return userDefaults.bool(forKey: Constants.onboardedKey)
    }
    
    typealias Symbol = String
    typealias CompanyName = String
    
    /// Set up default watch list items
    private func setUpDefaults() {
        let map: [Symbol: CompanyName] = [
            "BTC": "Apple Inc",
            "ETH": "Microsoft Corporation",
            
        ]
        
        let symbols = map.keys.map { $0 }
        userDefaults.set(symbols, forKey: Constants.watchListKey)
    }
}
