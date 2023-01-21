//
//  TabBarItemSettable.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/17.
//

import UIKit

protocol TabBarItemSettable { }
extension TabBarItemSettable where Self: UIViewController {
    func setupTabBarItem(title: String, image: UIImage?, selectedImage: UIImage? = nil) {
        tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
    }
}
