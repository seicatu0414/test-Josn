//
//  BaseTabBarController.swift
//  test-News-App
//
//  Created by yamaguchi kohei on 2024/03/25.
//

import UIKit

class BaseTabBarController:UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let mainViewController = viewController as? MainViewController {
            mainViewController.mainViewReload()
        } else if let followListViewController = viewController as? FollowListViewController {
            followListViewController.followListViewReload()
        }
    }
}
