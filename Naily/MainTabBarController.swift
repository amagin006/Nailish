//
//  MainTabBarController.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-05-30.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            createViewController(viewController: CustomerCollectionViewController(), title: "Customer", imageName: "customer"),
            createViewController(viewController: UIViewController(), title: "Calender", imageName: "calendar"),
            createViewController(viewController: UIViewController(), title: "Analysis", imageName: "analysis"),
            createViewController(viewController: UIViewController(), title: "Setting", imageName: "settings"),
            
        ]
        
    }
    

    fileprivate func createViewController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        
        viewController.view.backgroundColor = .white
        viewController.navigationItem.title = title
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = true
        navController.tabBarItem.title = title
        
        navController.tabBarItem.image = UIImage(named: imageName)
        
        return navController
    }
    

}
