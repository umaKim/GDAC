//
//  PortfolioWatchlistRepository.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/23.
//
import Combine
import Foundation

class PortfolioWatchlistRepositoryImp: WatchlistRepository {
   
    lazy var dataPublisher: AnyPublisher<[Datum], Never> = dataSubject.eraseToAnyPublisher()
    private var dataSubject = PassthroughSubject<[Datum], Never>()
    
    private let websocket: WebSocketProtocol
    private let persistance: PersistanceService
    
    init(
        websocket: WebSocketProtocol,
        persistance: PersistanceService
    ) {
        self.websocket = websocket
        self.persistance = persistance
    }
    
    private var symbols: [String] = []
    
    func fetchSymbols() -> AnyPublisher<CoinCapAssetResponse, Error> {
        Future<CoinCapAssetResponse, Error> { promise in
            promise(.success(CoinCapAssetResponse(data: self.persistance.watchlist)))
        }
        .eraseToAnyPublisher()
    }
}

//MARK: - Socket
extension PortfolioWatchlistRepositoryImp: StarScreamWebSocketDelegate {
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
