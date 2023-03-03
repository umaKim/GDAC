//
//  CoinInformationInteractor.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/20.
//
import UIKit
import Combine
import ModernRIBs

protocol CoinInformationRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CoinInformationPresentable: Presentable {
    var listener: CoinInformationPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func update(_ coinDetailMetaViewData: CoinDetailMetaViewData)
}

protocol CoinInformationListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol CoinInformationInteractorDependency {
    var symbol: AnyPublisher<CoinCapAsset, Never> { get }
    var coinDetailRepository: CoinMetaDataRepository { get }
}

final class CoinInformationInteractor: PresentableInteractor<CoinInformationPresentable>, CoinInformationInteractable, CoinInformationPresentableListener {

    private let dependency: CoinInformationInteractorDependency
    weak var router: CoinInformationRouting?
    weak var listener: CoinInformationListener?
    
    private var cancellables: Set<AnyCancellable>

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        dependency: CoinInformationInteractorDependency,
        presenter: CoinInformationPresentable
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
        
        dependency
            .symbol
            .sink {[weak self] coin in
                self?.fetchMetatData(of: coin.id)
            }
            .store(in: &cancellables)
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        cancellables.forEach({$0.cancel()})
        cancellables.removeAll()
    }
    
    private func fetchMetatData(of symbol: String) {
        dependency
            .coinDetailRepository
            .fetchMetaData(of: symbol)
            .receive(on: DispatchQueue.main)
            .sink { compl in
                switch compl {
                case .failure(let error):
                    print(error.localizedDescription)
                    
                case .finished:
                    break
                }
            } receiveValue: {[weak self] coinData in
                self?.configureCoinDetailMetaViewData(with: coinData)
            }
            .store(in: &cancellables)
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
}
