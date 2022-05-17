//
//  UITabBarControllerExtension.swift
//  iNova
//
//  Created by Mason Scherbarth on 5/13/22.
//
//  Used to center TabBar icons

import SwiftUI

extension UITabBarController {
    override open func viewDidLayoutSubviews() {
        
        let items = tabBar.items
        for item in items! {
            if item.title == nil {
                item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            }
        }
        
    }
}
