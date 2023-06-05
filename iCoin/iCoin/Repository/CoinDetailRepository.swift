//
//  CoinDetailRepository.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/16.
//
import Combine
import Foundation

protocol CoinDetailRepository {

    /// persistance
    func contains(_ symbol: CoinCapAsset) -> Bool
    func save(_ symbol: CoinCapAsset)
    func remove(_ symbol: CoinCapAsset)
    
    /// ws
    var dataPublisher: AnyPublisher<[Datum], Never> { get }
    func set(symbols: [String])
    func disconnect()
    func connect()
    
    /// networkManager
    func fetchMetaData(of symbol: String) -> AnyPublisher<CoinCapDetail, Error>
}

typealias CoinDetailNetworkable = CoinChartDataNetworkable & CoinCapMetaNetworkable

class CoinDetailRepositoryImp: CoinDetailRepository {
    private let persistance: PersistanceService
    private let websocket: WebSocketProtocol
    private let network: CoinDetailNetworkable
    
    lazy var dataPublisher: AnyPublisher<[Datum], Never> = dataSubject.eraseToAnyPublisher()
    private var dataSubject = PassthroughSubject<[Datum], Never>()
    
    init(
        _ persistance: PersistanceService,
        _ websocket: WebSocketProtocol,
        _ network: CoinDetailNetworkable
    ) {
        self.persistance = persistance
        self.websocket = websocket
        self.network = network
    }
    
    private var symbols = [String]()
}

// MARK: - Persistance
extension CoinDetailRepositoryImp {
    
    func contains(_ symbol: CoinCapAsset) -> Bool {
        persistance.watchlistContains(symbol: symbol)
    }
    
    func save(_ symbol: CoinCapAsset) {
        persistance.addToWatchlist(symbol: symbol)
    }
    
    func remove(_ symbol: CoinCapAsset) {
        persistance.removeFromWatchlist(symbol: symbol)
    }
}

// MARK: - Websocket
extension CoinDetailRepositoryImp: StarScreamWebSocketDelegate {
    
    func set(symbols: [String]) {
        self.symbols = symbols
    }
    
    func connect() {
        websocket.register(delegate: self)
        websocket.connect(to: FinnHubSocket())
    }
    
    func disconnect() {
        websocket.disconnect()
    }
    
    //MARK: - StarScreamWebSocketDelegate
    func cancelled() {
        connected()
    }
    
    func connected() {
        DispatchQueue.global().async {[weak self] in
            self?.symbols.forEach({ symbol in
                let symbolForFinHub = "BINANCE:\(symbol)USDT"
                let message = "{\"type\":\"subscribe\",\"symbol\":\"\(symbolForFinHub)\"}"
                self?.websocket.write(message)
            })
        }
    }
    
    func didReceive(_ text: String) {
        if let data: Data = text.data(using: .utf8) {
            if let tickData = try? WebSocketData.decode(from: data)?.data {
                self.dataSubject.send(tickData)
            }
        }
    }
}

// MARK: - Network
extension CoinDetailRepositoryImp {
    func fetchMetaData(of symbol: String) -> AnyPublisher<CoinCapDetail, Error> {
        network.fetchMetaData(of: symbol)
    }
}
