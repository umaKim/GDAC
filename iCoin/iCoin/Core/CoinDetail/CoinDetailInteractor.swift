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

final class CoinDetailInteractor: PresentableInteractor<CoinDetailPresentable>, CoinDetailInteractable, CoinDetailPresentableListener {
    
    weak var router: CoinDetailRouting?
    weak var listener: CoinDetailListener?

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
    
    private var symbol: CoinCapAsset?

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
        dependency
            .symbol
            .sink {[weak self] symbol in
                self?.symbol = symbol
                self?.checkIsFavorite(symbol: symbol)
                self?.fetchChartData(of: symbol.id)
                self?.fetchMetatData(of: symbol.id)
            }
            .store(in: &cancellables)
        
        #warning("check the symbol exist in PersistanceManager")
        #warning("if it exists then change the color of the favorite button")
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
                    print("error")
                }
            } receiveValue: {[weak self] coinData in
                self?.configureData(with: coinData)
            }
            .store(in: &cancellables)
    }
    
    private func fetchChartData(of symbol: String) {
        print(symbol)
        dependency
            .coinDetailRepository
            .fetchCoinChart(of: symbol, days: "\(1)")
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    print("finished")
                }
            } receiveValue: { data in
                self.configureCoinChartData(with: data)
            }
            .store(in: &cancellables)
    }
    
    private func configureData(with data: CoinCapDetail) {
        configureCoinLabelData(with: data)
        configureCoinPriceLabelData()
        configureCoinDetailMetaViewData(with: data)
    }
    
    private func configureCoinChartData(with data: CoinChartData) {
        let newData: [Double] = data.prices.map({ $0[1] })
        presenter.update(newData)
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
    
    private func checkIsFavorite(symbol: CoinCapAsset) {
        let symbolExist = dependency.coinDetailRepository.contains(symbol)
        presenter.doesSymbolInPersistance(symbolExist)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
        cancellables.forEach({$0.cancel()})
        cancellables.removeAll()
    }
    
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
