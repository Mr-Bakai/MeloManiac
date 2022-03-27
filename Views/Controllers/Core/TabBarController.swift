//
//  TabBarController.swift
//  MeloManiac
//
//  Created by Bakai Ismailov on 9/1/22.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = setupViewControllers()
    }
    
    private var moviesTabBar: HomeViewController = {
        
        let homeTabBar = HomeViewController()
        let title = "Home"
        let defaultImage = UIImage(systemName: "house")
        let selectedImage = UIImage(systemName: "house")
            
        let tabBarItem = UITabBarItem(title: title,
                                      image: defaultImage,
                                      selectedImage: selectedImage)
        
        homeTabBar.tabBarItem = tabBarItem
        homeTabBar.navigationItem.title = title
        return homeTabBar
    }()
    
    
    private var seriesTabBar: SearchViewController = {
        
        let searchTabBar = SearchViewController()
        let title = "Search"
        let defaultImage = UIImage(systemName: "magnifyingglass.circle")
        let selectedImage = UIImage(systemName: "magnifyingglass.circle")
        
        let tabBarItem = UITabBarItem(title: title,
                                      image: defaultImage,
                                      selectedImage: selectedImage)
        searchTabBar.tabBarItem = tabBarItem
        searchTabBar.navigationItem.title = title
        return searchTabBar
    }()
    
    
    private var exploreTabBar: LibraryViewController = {
        
        let libraryTabBar = LibraryViewController()
        let title = "Library"
        let defaultImage = UIImage(systemName: "music.note.list")
        let selectedImage = UIImage(systemName: "music.note.list")
        
        let tabBarItem = UITabBarItem(title: title,
                                      image: defaultImage,
                                      selectedImage: selectedImage)
        libraryTabBar.tabBarItem = tabBarItem
        libraryTabBar.navigationItem.title = title
        return libraryTabBar
    }()
    

    private func setupViewControllers() -> [UINavigationController]{
        let moviesVC = UINavigationController(rootViewController: moviesTabBar)
        let seriesVC = UINavigationController(rootViewController: seriesTabBar)
        let exploreVC = UINavigationController(rootViewController: exploreTabBar)
        return [moviesVC, seriesVC, exploreVC]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        print("Selected \(viewController.title!)")
    }
}
