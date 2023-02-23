//
//  ChartInteractor.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/20.
//

import UIKit
import Combine
import ModernRIBs

protocol ChartRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ChartPresentable: Presentable {
    var listener: ChartPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    
    func updateCandleStickChartView(with data: ChartData)
    func updateBarchartView(with data: ChartData)
}

protocol ChartListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol ChartInteractorDependency {
    var coinChartRepository: CoinChartRepository { get }
    var symbol: AnyPublisher<CoinCapAsset, Never> { get }
}

final class ChartInteractor: PresentableInteractor<ChartPresentable>, ChartInteractable, ChartPresentableListener {

    weak var router: ChartRouting?
    weak var listener: ChartListener?

    private let dependency: ChartInteractorDependency
    
    private var symbol: CoinCapAsset?
    private var cancellables: Set<AnyCancellable>
    
    init(
        presenter: ChartPresentable,
        dependency: ChartInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
        
        fetchSelectedSymbolStatus()
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}

// MARK: - Network
extension ChartInteractor {
    private func fetchSelectedSymbolStatus() {
        dependency
            .symbol
            .sink {[weak self] symbol in
                self?.symbol = symbol
                self?.fetchChartData(of: symbol.symbol)
            }
            .store(in: &cancellables)
    }
    
    private func fetchChartData(of symbol: String) {
        dependency
            .coinChartRepository
            .fetchChartData(of: symbol)
            .receive(on: DispatchQueue.main)
            .sink { comple in
                switch comple {
                case .finished:
                    break
                case .failure(let error):
                    break
                }
            } receiveValue: {[weak self] coinData in
                self?.updateCandleStickChartView(with: coinData)
                self?.updateBarChartView(with: coinData)
            }
            .store(in: &cancellables)
    }
    
    private func updateCandleStickChartView(with data: ChartData) {
        presenter.updateCandleStickChartView(with: data)
    }
    
    private func updateBarChartView(with data: ChartData) {
        presenter.updateBarchartView(with: data)
    }
}
