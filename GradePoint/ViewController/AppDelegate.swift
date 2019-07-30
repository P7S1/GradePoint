//
//  AppDelegate.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 7/14/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import CoreData
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        loadClasses()
        
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationBarAppearace.barTintColor = #colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 1)
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationBarAppearace.titleTextAttributes = textAttributes
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        saveItems()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        saveItems()
    }
    func loadClasses(){
        if let data =  try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                try  classArray = decoder.decode([Course].self, from: data)
            }
            catch{
                print("error loading items \(error)")
            }
        }
    }
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(classArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Error encoding class array \(error)")
        }
    }


}
