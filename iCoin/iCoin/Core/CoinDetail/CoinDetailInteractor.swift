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
}

protocol CoinDetailPresentable: Presentable {
    var listener: CoinDetailPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    
    func update(symbol: CoinCapAsset)
    func update(_ coinLabelData: CoinLabelData)
    func update(_ coinPriceData: CoinPriceLabelData)
    func update(_ coinChartData: [Double])
    func update(_ coinDetailMetaViewData: CoinDetailMetaViewData)
    func doesSymbolInPersistance(_ exist: Bool)
}

protocol CoinDetailListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func coinDetailDidTapBackButton()
}

protocol CoinDetailInteractorDependency {
    var coinDetailRepository: CoinDetailRepository { get }
    var symbol: AnyPublisher<CoinCapAsset, Never> { get }
}

final class CoinDetailInteractor: PresentableInteractor<CoinDetailPresentable>, CoinDetailInteractable {
   
    weak var router: CoinDetailRouting?
    weak var listener: CoinDetailListener?
    
    private lazy var selectedCharData: [String: [Double]] = [
        "1" : [],
        "7" : [],
        "14": [],
        "30": [],
        "365": []
    ]
    
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
    }
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
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
    private func fetchSelectedSymbolStatus() {
        dependency
            .symbol
            .sink {[weak self] symbol in
                self?.symbol = symbol
                self?.checkIsFavorite(symbol: symbol)
                self?.fetchChartData(of: symbol.id, days: "\(1)")
                self?.fetchMetatData(of: symbol.id)
            }
            .store(in: &cancellables)
    }
    
    private func fetchChartData(of symbol: String, days: String) {
        dependency
            .coinDetailRepository
            .fetchCoinChart(of: symbol, days: days)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    print("finished")
                }
            } receiveValue: {[weak self] data in
                guard let self = self else { return }
                self.selectedCharData[days] = data.prices.map({$0[1]})
                self.configureCoinChartData(with: data)
            }
            .store(in: &cancellables)
    }
    
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
}

// MARK: - Data Mapper
extension CoinDetailInteractor {
    private func configureData(with data: CoinCapDetail) {
        configureCoinLabelData(with: data)
        configureCoinPriceLabelData()
        configureCoinDetailMetaViewData(with: data)
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
            priceChnagePercentage: "$\(symbol.changePercent24Hr.toDollarDecimal ?? "")"
        ))
    }
    
    private func configureCoinDetailMetaViewData(with data: CoinCapDetail) {
        let data = CoinDetailMetaViewData(
            description: data.description.en,
            metaDatum: [
                .init(title: "Price Change 24h", value:"$\(data.market_data.price_change_24h)" ),
                .init(title: "Price Change (24h)", value: "\(data.market_data.price_change_percentage_24h)%"),
                .init(title: "Price Change (7d)", value: "\(data.market_data.price_change_percentage_7d)%"),
                .init(title: "Price Change (14d)", value: "\(data.market_data.price_change_percentage_14d)%"),
                .init(title: "Price Change (30d)", value: "\(data.market_data.price_change_percentage_30d)%"),
                .init(title: "Price Change (60d)", value: "\(data.market_data.price_change_percentage_60d)%"),
                .init(title: "Price Change (200d)", value: "\(data.market_data.price_change_percentage_200d)%"),
                .init(title: "Price Change (1y)", value: "\(data.market_data.price_change_percentage_1y)%"),
                .init(title: "Market Cap Change 24h", value: "$\(data.market_data.market_cap_change_24h)"),
                .init(title: "Market Cap Change (24h)", value: "\(data.market_data.market_cap_change_percentage_24h)%")
            ]
        )
        presenter.update(data)
    }
    
    private func configureCoinChartData(with data: CoinChartData) {
        let newData: [Double] = data.prices.map({ $0[1] })
        presenter.update(newData)
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
    
    func selectedDays(_ days: String) {
        if let selectedDay = selectedCharData[days],
           selectedDay.isEmpty {
            guard let symbol = symbol else { return }
            fetchChartData(of: symbol.id, days: days)
        } else {
            presenter.update(selectedCharData[days] ?? [])
        }
    }
}
