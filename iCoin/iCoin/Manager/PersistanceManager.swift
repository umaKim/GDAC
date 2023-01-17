//
//  PersistanceManager.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/07.
//
import Combine
import Foundation

protocol PersistanceService {
    var watchlist: [SymbolResult] { get }
    func watchlistContains(symbol: SymbolResult) -> Bool
    func addToWatchlist(symbol: SymbolResult)
    func removeFromWatchlist(symbol: SymbolResult)
}

final class PersistanceManager: PersistanceService {
    /// Reference to user defaults
    private let userDefaults: UserDefaults = .standard
    
    /// Constants
    private struct Constants {
        static let onboardedKey = "hasOnboarded"
        static let watchListKey = "watchlist"
    }
    
    // MARK: - Public
    
    /// Get usr watch list
    public var watchlist: [SymbolResult] {
        do {
            let symbolResults = try userDefaults.getObject(forKey: Constants.watchListKey, castTo: [SymbolResult].self)
            return symbolResults
        } catch {
            return []
        }
    }
    
    /// Check if watch list contains item
    /// - Parameter symbol: Symbol to check
    /// - Returns: Boolean
    public func watchlistContains(symbol: SymbolResult) -> Bool {
        watchlist.contains(symbol)
    }
    
    /// Add a symbol to watch list
    /// - Parameters:
    ///   - symbol: Symbol to add
    ///   - companyName: Company name for symbol being added
    public func addToWatchlist(symbol: SymbolResult) {
        if !watchlistContains(symbol: symbol) {
            var current = watchlist
            current.append(symbol)
            do {
                try userDefaults.setObject(current, forKey: Constants.watchListKey)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    /// Remove item from watchlist
    /// - Parameter symbol: Symbol to remove
    public func removeFromWatchlist(symbol: SymbolResult) {
        var newList = [SymbolResult]()
        
        for item in watchlist where item != symbol {
            newList.append(item)
        }
        
        do {
            try userDefaults.setObject(newList, forKey: Constants.watchListKey)
        } catch {
            print(error.localizedDescription)
        }
    }
}
