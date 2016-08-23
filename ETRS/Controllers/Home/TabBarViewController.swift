//
//  TabBarViewController.swift
//  ETRS
//
//  Created by BBaoBao on 9/10/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class TabBarViewController: YALFoldingTabBarController {
    
    let tabItemLeft1: YALTabBarItem = YALTabBarItem(itemImage: UIImage(named: "TimeRecord"), leftItemImage: nil, rightItemImage: nil)
    let tabItemLeft2: YALTabBarItem = YALTabBarItem(itemImage: UIImage(named: "Information"), leftItemImage: UIImage(named: "Month"), rightItemImage: UIImage(named: "Year"))
    let tabItemRight1: YALTabBarItem = YALTabBarItem(itemImage: UIImage(named: "Profile"), leftItemImage: nil, rightItemImage: nil)
    let tabItemRight2: YALTabBarItem = YALTabBarItem(itemImage: UIImage(named: "Utilities"), leftItemImage: nil, rightItemImage: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Items on the left of tab bar
        super.leftBarItems = [tabItemLeft1,tabItemLeft2]
        //Items on the right of tab bar
        super.rightBarItems = [tabItemRight2,tabItemRight1]
        //Center button of tab bar
        super.centerButtonImage = UIImage(named: "Add")
        
        //Customize tabBarView
        //Specify height
        super.tabBarViewHeight = YALTabBarViewDefaultHeight
        //Specify insets and offsets
        super.tabBarView.tabBarViewEdgeInsets = YALTabBarViewHDefaultEdgeInsets
        super.tabBarView.tabBarItemsEdgeInsets = YALTabBarViewItemsDefaultEdgeInsets
        super.tabBarView.offsetForExtraTabBarItems = YALForExtraTabBarItemsDefaultOffset
        //Specify colors
        super.tabBarView.backgroundColor = UIColor.clearColor()
        super.tabBarView.tabBarColor = UIColor.MKColor.Green
        //Specify height for additional left and right buttons
        super.tabBarView.extraTabBarItemHeight = YALExtraTabBarItemsDefaultHeight
    }
}
