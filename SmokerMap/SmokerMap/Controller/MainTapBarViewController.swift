//
//  MainTapBarController.swift
//  SmokerMap
//
//  Created by 정의석 on 2020/03/09.
//  Copyright © 2020 pandaman. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {
//  private let loginVC = UINavigationController(rootViewController: LoginViewController())
  private let smokingAreaVC = UINavigationController(rootViewController: SmokingAreaViewController())
    private let timerVC = UINavigationController(rootViewController: TimerViewController())
    
  override func viewDidLoad() {
    super.viewDidLoad()
    smokingAreaVC.tabBarItem = UITabBarItem(title: "Area", image: UIImage(systemName: "map"), tag: 0)
    smokingAreaVC.tabBarItem.selectedImage = UIImage(systemName: "map.fill")
    
    timerVC.tabBarItem = UITabBarItem(title: "Timer", image: UIImage(systemName: "chart.pie"), tag: 2)
    timerVC.tabBarItem.selectedImage = UIImage(systemName: "chart.pie.fill")
    if self.traitCollection.userInterfaceStyle == .dark {
        tabBar.tintColor = .lightGray
    } else {
        tabBar.tintColor = .orange
    }
    viewControllers = [smokingAreaVC,timerVC]
  }
}
