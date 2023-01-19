//
//  CoinDetailInteractor.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/07.
//
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
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
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
                self?.presenter.update(symbol: symbol)
                self?.checkIsFavorite(symbol: symbol)
            }
            .store(in: &cancellables)
        
        #warning("check the symbol exist in PersistanceManager")
        #warning("if it exists then change the color of the favorite button")
    }
    
    private func checkIsFavorite(symbol: SymbolResult) {
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
