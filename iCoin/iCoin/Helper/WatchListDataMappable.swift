//
//  WatchListDataMappable.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/13.
//

import Foundation

protocol WatchListDataMappable {
    var watchlistItemModels: [WatchlistItemModel] { get set }
    var symbols: [SymbolResult] { get set }
}

extension WatchListDataMappable {
    func myWatchlistItemMapper(receivedDatum: [Datum]) -> [WatchlistItemModel] {
        var watchlistItemModels = self.watchlistItemModels
        receivedDatum.forEach { data in
            //if watchlistItemModels already has the Symbol
            if watchlistItemModels.contains(where: {
                $0.detailName.uppercased() == data.s
            }) {
                for (index, model) in self.watchlistItemModels.enumerated() {
                    if model.detailName.uppercased() == data.s {
                        watchlistItemModels[index].price = "$\(data.p)"
                    }
                }
            } else {
            // if WatchlistItemModels are empty
                self.symbols.forEach { symbol in
                    print(symbol)
                    if "BINANCE:\(symbol.symbol.uppercased())USDT" == data.s {
                        watchlistItemModels.append(.init(
                            symbol: symbol.displaySymbol,
                            detailName: data.s,
                            price: "$\(data.p)",
                            changeColor: .clear,
                            changePercentage: ""
                        ))
                    }
                }
            }
        }
        return watchlistItemModels
    }
}
