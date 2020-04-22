//
//  AppDelegate.swift
//  uselessApp
//
//  Created by Tamara Erlij on 17/04/20.
//  Copyright © 2020 Tamara Erlij. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

        var window: UIWindow?


        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            
            //To display onboarding
            window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: K.main, bundle: nil)
            var viewController: UIViewController
            
//            if (UserDefaults.standard.value(forKey: K.onboardScreenShown) as? String) == nil {
//                viewController = storyboard.instantiateViewController(withIdentifier: K.onboardingViewController)
//            } else {
                viewController = storyboard.instantiateInitialViewController()!
         //   }
            window?.rootViewController = viewController
            window?.makeKeyAndVisible()
                    
            return true
        }

        func applicationWillResignActive(_ application: UIApplication) {
        
        }

        func applicationDidEnterBackground(_ application: UIApplication) {
       
        }

        func applicationWillEnterForeground(_ application: UIApplication) {
    
        }

        func applicationDidBecomeActive(_ application: UIApplication) {
         
        }

        func applicationWillTerminate(_ application: UIApplication) {

        }


    }

