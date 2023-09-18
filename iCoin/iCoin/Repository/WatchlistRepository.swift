//
//  WatchlistRepository.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/16.
//
import Starscream
import Combine
import Foundation

protocol WatchlistRepository {
    // MARK: - Socket
    var dataPublisher: AnyPublisher<[Datum], Never> { get }
    func set(symbols: [String])
    func disconnect()
    func connect()
    
    // MARK: - Network for fetching Asset list
    func fetchSymbols() -> AnyPublisher<CoinCapAssetResponse, Error>
}

class WatchlistRepositoryImp: WatchlistRepository {
    private let websocket: WebSocketProtocol
    private let network: CoinCapAssetNetworkable
    
    lazy var dataPublisher: AnyPublisher<[Datum], Never> = dataSubject.eraseToAnyPublisher()
    private var dataSubject = PassthroughSubject<[Datum], Never>()
    
    init(
        websocket: WebSocketProtocol,
        network: CoinCapAssetNetworkable
    ) {
        self.websocket = websocket
        self.network = network
    }
    
    private var symbols: [String] = []
}

//MARK: - Socket API
extension WatchlistRepositoryImp: StarScreamWebSocketDelegate {
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
    
    // MARK: - StarScreamWebSocketDelegate
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

//MARK: - REST API
extension WatchlistRepositoryImp {
    func fetchSymbols() -> AnyPublisher<CoinCapAssetResponse, Error> {
        network.fetchCoinCapAssets()
    }
}
