//
//  WatchlistRepository.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/07.
//
import Combine
import Foundation

protocol WatchlistRepository {
    func fetch(symbols: [String]) -> AnyPublisher<[Datum], Never>
    func stopFetch()
    func resume()
}

final class WatchlistRepositoryImp: WatchlistRepository {
    
    private let websocket: WebSocketProtocol
    
    private var cancellables: Set<AnyCancellable>
    
    init(websocket: WebSocketProtocol) {
        self.websocket = websocket
        self.cancellables = .init()
    }
    
    func fetch(symbols: [String]) -> AnyPublisher<[Datum], Never> {
        websocket.webSocket(symbols: symbols)
        websocket.receiveMessage()
        
        return websocket
            .dataPublisher
            .eraseToAnyPublisher()
    }
    
    func stopFetch() {
        websocket.disconnect()
    }
    
    func resume() {
        websocket.resume()
    }
}
