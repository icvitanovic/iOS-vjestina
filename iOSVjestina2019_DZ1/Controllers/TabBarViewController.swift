//
//  TabBarViewController.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 26/06/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let nvc = UINavigationController(rootViewController: QuizzesViewController())
        let settingsVc = SettingsViewController()
        let searchNavigationVc = UINavigationController(rootViewController: SearchViewController())
        
        nvc.tabBarItem = UITabBarItem(title: "Quizzes", image: UIImage(named: "quizzes-icon"), tag: 0)
        searchNavigationVc.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "search-icon"), tag: 1)
        settingsVc.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settings-icon"), tag: 2)
        
        self.viewControllers = [nvc, searchNavigationVc, settingsVc]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
