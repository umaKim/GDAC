//
//  ChartViewController.swift
//  iCoin
//
//  Created by 김윤석 on 2023/02/20.
//

import ModernRIBs
import UIKit

protocol ChartPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class ChartViewController: UIViewController, ChartPresentable, ChartViewControllable {
   
    weak var listener: ChartPresentableListener?
    
    private let contentView = ChartView()
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    func updateCandleStickChartView(with data: ChartData) {
        contentView.updateCandleStickChartView(with: data)
    }
    
    func updateBarchartView(with data: ChartData) {
//        contentView.updateBarChartView(with: data)
    }
}
