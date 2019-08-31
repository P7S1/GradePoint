//
//  AppDelegate.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 7/14/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import UserNotifications

import GoogleMobileAds
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
 
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        loadClasses()
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)

        

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
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
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
        
        if let data =  try? Data(contentsOf: remindersDataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                try  reminders = decoder.decode([Reminder].self, from: data)
                
            }
            catch{
                print("error loading items \(error)")
            }
        }
        
        if let data =  try? Data(contentsOf: completedDataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                try  completedReminderes = decoder.decode([Reminder].self, from: data)
            }
            catch{
                print("error loading items \(error)")
            }
        }
        
        if let data =  try? Data(contentsOf: weightsDataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                try  weights = decoder.decode(CourseWeights.self, from: data)
                    print(weights.honors)
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
        
        do{
            let data = try encoder.encode(reminders)
            try data.write(to: remindersDataFilePath!)
            
        }catch{
            print("Error encoding class array \(error)")
        }
        
        do{
            let data = try encoder.encode(completedReminderes)
            try data.write(to: completedDataFilePath!)
            
        }catch{
            print("Error encoding class array \(error)")
        }
        
        do{
            let data = try encoder.encode(weights)
            try data.write(to: weightsDataFilePath!)
            
        }catch{
            print("Error encoding weights array \(error)")
        }
        if(reminders.count>0){
        for i in 0...reminders.count-1{
            if(reminders.count > 0){
            scheduleLocal(remind: reminders[i])
            }
        }
        }
        
    }
    
    func scheduleLocal(remind: Reminder){
        if(remind.willNotify && !remind.completed){
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = NotificationPhrases().getPhrase()
            if remind.course.name != Course().name && remind.course.name != "No class"{
            content.body = "\(remind.name) for \(remind.course.name)"
            }else{
            content.body = remind.name
            }
            content.sound = .default

            let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: remind.reminder)
            
            print(comps)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
            
            
            print(Date())
            // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            print("Set reminder for \(remind.reminder)")
            center.add(request)
            print("notification added successfully")
        }
    }


}

