//
//  BaseTapBarController.swift
//  AppStore
//
//  Created by Лилия on 03.11.2021.
//

import UIKit

class BaseTapBarController: UITabBarController {
    
    // MARK: - Properties
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        
        setupAppearance()
    }
    
    // MARK: - Helper Functions
    
    private func createNavigationController(for rootViewCotroller: UIViewController, title: String, image: UIImage) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: rootViewCotroller)
        
        rootViewCotroller.navigationItem.title = title
        
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        
        return navController
    }
    
    private func setupViewControllers() {
        
//        viewControllers = [
//            createNavigationController(for: MusicController(), title: "Music", image: .musicImage),
//            createNavigationController(for: TodayController(), title: "Today", image: .todayImage),
//            createNavigationController(for: AppsController(), title: "Apps", image: .AppsImage),
//            createNavigationController(for: AppSearchController() , title: "Search", image: .searchImage)
//        ]
        
        viewControllers = [
            createNavigationController(for: TodayController(), title: "Today", image: .todayImage),
            createNavigationController(for: AppSearchController() , title: "Search", image: .searchImage),
            createNavigationController(for: AppsController(), title: "Apps", image: .AppsImage)
        ]
        
    }
    
    
    
    private func setupAppearance() {
       
        if #available(iOS 15, *) {
            
            let defaultTabBarAppearance = UITabBarAppearance()
            defaultTabBarAppearance.configureWithDefaultBackground() // for clarity
            UITabBar.appearance().standardAppearance = defaultTabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = defaultTabBarAppearance
            
            let defaultNavBarAppearance = UINavigationBarAppearance()
            defaultNavBarAppearance.configureWithDefaultBackground() // for clarity
            UINavigationBar.appearance().standardAppearance = defaultNavBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = defaultNavBarAppearance
            
        }
        
//        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
//        let statusBarColor = UIColor(white: 1, alpha: 0.7)
//        statusBarView.backgroundColor = statusBarColor
//        view.addSubview(statusBarView)
//
//        UINavigationBar.appearance().backgroundColor = UIColor(white: 1, alpha: 0.7)
//        tabBar.backgroundColor = UIColor(white: 1, alpha: 0.7)
        
    }
    
}
