//
//  CoinDetailRouter.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/07.
//

import ModernRIBs

protocol CoinDetailInteractable: Interactable,
                                 ChartListener,
                                 OrderBookListener,
                                 CoinInformationListener {
    var router: CoinDetailRouting? { get set }
    var listener: CoinDetailListener? { get set }
}

protocol CoinDetailViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func setChart(_ view: ViewControllable)
    func setOrderBook(_ view: ViewControllable)
    func setMeta(_ view: ViewControllable)
}

final class CoinDetailRouter: ViewableRouter<CoinDetailInteractable, CoinDetailViewControllable>, CoinDetailRouting {
    private let chart: ChartBuildable
    private var chartRouting: Routing?
    
    private let orderBook: OrderBookBuildable
    private var orderBookRouting: Routing?
    
    private let coinInformation: CoinInformationBuildable
    private var coinInformationRouting: Routing?
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: CoinDetailInteractable,
        viewController: CoinDetailViewControllable,
        chartBuilderable: ChartBuildable,
        orderBookBuilderable: OrderBookBuildable,
        coinInformationBuilderable: CoinInformationBuildable
    ) {
        self.chart = chartBuilderable
        self.orderBook = orderBookBuilderable
        self.coinInformation = coinInformationBuilderable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    
    //MARK: - Chart
    func attachChart() {
        if chartRouting != nil { return }
        let router = chart.build(withListener: interactor)
        let chart = router.viewControllable
        viewController.setChart(chart)
        chartRouting = router
        attachChild(router)
    }
    
    func detachChart() {
        guard let router = chartRouting else { return }
        detachChild(router)
        chartRouting = nil
    }
    
    //MARK: - OrderBook
    func attachOrderBook() {
        if orderBookRouting != nil { return }
        let router = orderBook.build(withListener: interactor)
        let chart = router.viewControllable
        viewController.setOrderBook(chart)
        chartRouting = router
        attachChild(router)
    }
    
    func detatchOrderBook() {
        guard let router = orderBookRouting else { return }
        detachChild(router)
        orderBookRouting = nil
    }
    
    
    //MARK: - CoinInformation
    func attachCoinInformation() {
        if coinInformationRouting != nil { return }
        let router = coinInformation.build(withListener: interactor)
        let coinInformation = router.viewControllable
        viewController.setMeta(coinInformation)
        coinInformationRouting = router
        attachChild(router)
    }
    
    func detachCoinInformation() {
        guard let router = coinInformationRouting else { return }
        detachChild(router)
        coinInformationRouting = nil
    }
}
