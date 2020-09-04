//
//  AppDelegate.swift
//  SmokerMap
//
//  Created by 정의석 on 2020/03/09.
//  Copyright © 2020 pandaman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import NMapsMap

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        NMFAuthManager.shared().clientId = "hor3hyzr9p"
        
        do{
            try Auth.auth().signOut()
        }catch{
            print("Error while signing out!")
        }
        
        if Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.backgroundColor = .white
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
            
            return true
        } else {
            let vc = MainTabBarViewController()
            
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.backgroundColor = .white
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
            
            return true
            
        }
        
    }
    
}
