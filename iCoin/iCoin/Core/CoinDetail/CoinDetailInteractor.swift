//
//  CoinDetailInteractor.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/07.
//
import Foundation
import Combine
import ModernRIBs

protocol CoinDetailRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    
    func attachChart()
    func detachChart()
    
    func attachOrderBook()
    func detatchOrderBook()
    
    func attachCoinInformation()
    func detachCoinInformation()
}

protocol CoinDetailPresentable: Presentable {
    var listener: CoinDetailPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    
    func update(symbol: CoinCapAsset)
    func update(_ coinLabelData: CoinLabelData)
    func update(_ coinPriceData: CoinPriceLabelData)
    func doesSymbolInPersistance(_ exist: Bool)
}

protocol CoinDetailListener: AnyObject {
    func coinDetailDidTapBackButton()
}

protocol CoinDetailInteractorDependency {
    var coinDetailRepository: CoinDetailRepository { get }
    var symbol: AnyPublisher<CoinCapAsset, Never> { get }
}

final class CoinDetailInteractor: PresentableInteractor<CoinDetailPresentable>, CoinDetailInteractable {
   
    weak var router: CoinDetailRouting?
    weak var listener: CoinDetailListener?
     
    private var symbol: CoinCapAsset?

    private let dependency: CoinDetailInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    init(
        presenter: CoinDetailPresentable,
        dependency: CoinDetailInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        fetchSelectedSymbolStatus()
        router?.attachChart()
        router?.attachOrderBook()
        router?.attachCoinInformation()
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
        router?.detachChart()
        router?.detatchOrderBook()
        router?.detachCoinInformation()
        cancellables.forEach({$0.cancel()})
        cancellables.removeAll()
    }
}

// MARK: - to Presentable
extension CoinDetailInteractor {
    private func checkIsFavorite(symbol: CoinCapAsset) {
        let symbolExist = dependency.coinDetailRepository.contains(symbol)
        presenter.doesSymbolInPersistance(symbolExist)
    }
}

// MARK: - Network
extension CoinDetailInteractor {
    
    /// for receiving selected symbol from parents view
    private func fetchSelectedSymbolStatus() {
        dependency
            .symbol
            .sink {[weak self] symbol in
                self?.symbol = symbol
                self?.presenter.update(symbol: symbol)
                self?.checkIsFavorite(symbol: symbol)
                self?.fetchMetatData(of: symbol.id)
                self?.fetchFromSocket(symbols: [symbol.symbol])
            }
            .store(in: &cancellables)
    }
    
    /// for fetching coin image and its price
    private func fetchMetatData(of symbol: String) {
        dependency
            .coinDetailRepository
            .fetchMetaData(of: symbol)
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .finished:
                    print("finished")

                case .failure(let error):
                    print(error)
                }
            } receiveValue: {[weak self] coinData in
                self?.configureData(with: coinData)
            }
            .store(in: &cancellables)
    }
    
    /// for fetching real time price change
    private func fetchFromSocket(symbols: [String]) {
        connectWebSocket()
        
        dependency
            .coinDetailRepository
            .set(symbols: symbols)
        
        dependency
            .coinDetailRepository
            .dataPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finished fetchFromNetwork")
                }
            }, receiveValue: {[weak self] datum in
                guard let self = self else { return }
                guard
                    let price = datum.first?.p,
                    let price24hr = self.symbol?.changePercent24Hr.toDollarDecimal
                else { return }
                self.presenter.update(.init(
                    price: "$\(price)",
                    priceChnagePercentage: "\(price24hr)%"
                ))
            })
            .store(in: &cancellables)
    }
    
    private func connectWebSocket() {
        dependency
            .coinDetailRepository
            .connect()
    }
    
    private func disconnectWebSocket() {
        dependency
            .coinDetailRepository
            .disconnect()
    }
}

// MARK: - Data Mapper
extension CoinDetailInteractor {
    private func configureData(with data: CoinCapDetail) {
        configureCoinLabelData(with: data)
        configureCoinPriceLabelData()
    }
    
    private func configureCoinLabelData(with data: CoinCapDetail) {
        data.image.large.downloaded {[weak self] receivedImage in
            let data = CoinLabelData(
                image: receivedImage,
                name: data.name,
                symbol: data.symbol
            )
            self?.presenter.update(data)
        }
    }
    
    private func configureCoinPriceLabelData() {
        guard let symbol = symbol else { return }
        presenter.update(.init(
            price: "$\(symbol.priceUsd.toDollarDecimal ?? "")",
            priceChnagePercentage: "\(symbol.changePercent24Hr.toDollarDecimal ?? "")%"
        ))
    }
}

// MARK: - CoinDetailPresentableListener
extension CoinDetailInteractor: CoinDetailPresentableListener {
    func didTapBackButton() {
        listener?.coinDetailDidTapBackButton()
    }

    func didTapFavoriteButton() {
        guard let symbol = self.symbol else { return }
        let symbolExist = dependency.coinDetailRepository.contains(symbol)
        if symbolExist {
            dependency.coinDetailRepository.remove(symbol)
        } else {
            dependency.coinDetailRepository.save(symbol)
        }
        presenter.doesSymbolInPersistance(!symbolExist)
    }
}
