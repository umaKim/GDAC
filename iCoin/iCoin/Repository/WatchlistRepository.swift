//
//  WatchlistRepository.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/07.
//
import Combine
import Foundation

protocol WatchlistRepository {
//    var dataPublisher: AnyPublisher<[Datum], Never> { get }
    func fetch(symbols: [String]) -> AnyPublisher<[Datum], Never>
}

final class WatchlistRepositoryImp: WatchlistRepository {
    
//    lazy var dataPublisher: AnyPublisher<[Datum], Never> = dataStreamSubject.eraseToAnyPublisher()
//    private var dataStreamSubject = PassthroughSubject<[Datum], Never>()
    
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
}
