//
//  WebsocketManager.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/07.
//
import Combine
import Foundation

protocol WebSocketProtocol {
    var dataPublisher: PassthroughSubject<[Datum], Never> { get set }
    func webSocket(symbols: [String])
    func receiveMessage()
    func disconnect()
    func resume()
}

final class WebSocketManager : WebSocketProtocol, UrlConfigurable {
    
    
    fileprivate enum CryptoConstants {
        static let apiKey = "c3c6me2ad3iefuuilms0"
        static let baseUrl = "wss://ws.finnhub.io"
    }
    
    private var webSocketTask : URLSessionWebSocketTask?
    
    var dataPublisher = PassthroughSubject<[Datum], Never>()
    
    init() {
        resume()
    }
    
    func resume() {
        guard
            let url = url(for: CryptoConstants.baseUrl, with: ["token" : CryptoConstants.apiKey])
        else {
            print("unable to url")
            return }
        webSocketTask = URLSession(configuration: .default).webSocketTask(with: url)
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
    
    /// Setup Websocket with specific input values
    func webSocket(symbols: [String]) {
        DispatchQueue.global().async {
            let set = Set(symbols)
            for symbol in set {
                let symbolForFinHub = "BINANCE:\(symbol)USDT"
                let message = URLSessionWebSocketTask.Message.string("{\"type\":\"subscribe\",\"symbol\":\"\(symbolForFinHub)\"}")
                
                self.webSocketTask?.send(message) { error in
                    if let error = error {
                        print("WebSocket couldn’t send message because: \(error)")
                    }
                }
            }
            self.webSocketTask?.resume()
            self.ping()
        }
    }
    
    private func ping() {
        DispatchQueue.global().async(qos: .utility) {
            self.webSocketTask?.sendPing { error in
                if let error = error {
                    print("Error when sending PING \(error)")
                } else {
                    print("Web Socket connection is alive")
                    DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                        self.ping()
                    }
                }
            }
        }
    }
    
    /// Perform Websocket
    func receiveMessage() {
        DispatchQueue.global().async {
            self.webSocketTask?.receive { [weak self] result in
                guard let self = self else {return}
                switch result {
                case .failure(let error):
                    print("Error in receiving message: \(error)")
                case .success(let message):
                    switch message {
                    case .string(let text):
                        if let data: Data = text.data(using: .utf8) {
                            if let tickData = try? WebSocketData.decode(from: data)?.data {
                                self.dataPublisher.send(tickData)
                            }
                        }
                    case .data(let data):
                        print("Received data: \(data)")
                    @unknown default:
                        fatalError()
                    }
                    self.receiveMessage()
                }
            }
        }
    }
}
