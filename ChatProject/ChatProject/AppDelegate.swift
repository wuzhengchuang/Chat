//
//  AppDelegate.swift
//  ChatProject
//
//  Created by 吴闯 on 2023/2/27.
//

import UIKit
import SnapKit
import MJRefresh

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor=UIColor.white
        self.window?.rootViewController=CCTabBarController()
        self.window?.makeKeyAndVisible()
        return true
    }
}

