//
//  WebsocketManager.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/07.
//
import Combine
import Starscream
import Foundation

protocol StarScreamWebSocketDelegate: AnyObject {
    func didReceive(_ text: String)
    func connected()
    func cancelled()
}

protocol WebSocketProtocol {
    func register(delegate: StarScreamWebSocketDelegate)
    func write(_ text: String)
    func connect(to wsRequestable: WebsocketRequestable)
    func disconnect()
}

enum WebsocketRequestType: String {
    case finnhub = "wss://ws.finnhub.io"
}

protocol WebsocketRequestable {
    func urlMaker() -> URL
}

struct FinnHubSocket: WebsocketRequestable, UrlConfigurable {
    func urlMaker() -> URL {
        url(
            for: CryptoConstants.baseUrl,
            with: ["token" : CryptoConstants.apiKey]
        )!
    }
    
    fileprivate enum CryptoConstants {
        static let apiKey = "c3c6me2ad3iefuuilms0"
        static let baseUrl = "wss://ws.finnhub.io"
    }
}

struct BithumSocket: WebsocketRequestable, UrlConfigurable {
    func urlMaker() -> URL {
        url(for:  "wss://pubwss.bithumb.com/pub/ws")!
    }
    
    fileprivate enum BithumConstants {
        static let baseUrl = "wss://pubwss.bithumb.com/pub/ws"
    }
}

final class StarScreamWebSocket: WebSocketProtocol, UrlConfigurable {
    
    private var socket: WebSocket?
    
    private func configure(with websocketRequestable: WebsocketRequestable) {
        var request = URLRequest(url: websocketRequestable.urlMaker())
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket?.delegate = self
    }
    
    func register(delegate: StarScreamWebSocketDelegate) {
        self.delegate = delegate
    }
    
    private weak var delegate: StarScreamWebSocketDelegate?
    
    func connect(to wsRequestable: WebsocketRequestable) {
        configure(with: wsRequestable)
        socket?.connect()
    }
    
    func disconnect() {
        socket?.disconnect()
        socket?.delegate = nil
    }
    
    fileprivate enum CryptoConstants {
        static let apiKey = "c3c6me2ad3iefuuilms0"
        static let baseUrl = "wss://ws.finnhub.io"
    }
    
    fileprivate enum BithumConstants {
        static let baseUrl = "wss://pubwss.bithumb.com/pub/ws"
    }
    
    func write(_ text: String) {
        socket?.write(string: text)
    }
}

extension StarScreamWebSocket: Starscream.WebSocketDelegate {
    func didReceive(
        event: Starscream.WebSocketEvent,
        client: Starscream.WebSocketClient
    ) {
        switch event {
        case .connected:
            self.delegate?.connected()
            
        case .disconnected(let reason, _):
            delegate = nil
            socket = nil
            print(reason)
            
        case .text(let text):
            self.delegate?.didReceive(text)
            
        case .binary:
            break
        case .ping:
            break
        case .pong:
            break
        case .viabilityChanged:
            print("viabilityChanged")
            break
        case .reconnectSuggested:
            print("reconnectSuggested")
            break
        case .cancelled:
            print("cancelled")
            delegate?.cancelled()
            
        case .error(let error):
            print(error?.localizedDescription)
            break
        }
    }
}
