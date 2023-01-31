//
//  iCoin_WidgetBundle.swift
//  iCoin-Widget
//
//  Created by 김윤석 on 2023/01/31.
//

import WidgetKit
import SwiftUI

@main
struct iCoin_WidgetBundle: WidgetBundle {
    var body: some Widget {
        iCoin_Widget()
        iCoin_WidgetLiveActivity()
    }
}
