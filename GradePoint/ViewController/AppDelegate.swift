//
//  AppDelegate.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 7/14/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import UserNotifications
import RealmSwift
import SwiftyStoreKit
import GoogleMobileAds
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
 
    var oldClassArray : [Course] = [Course]()
    
    var oldReminders : [oldReminder] = [oldReminder]()
    
    var oldCompleted : [oldReminder] = [oldReminder]()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let currentCount = UserDefaults.standard.integer(forKey: "launchCount")
        
        // increment received number by one
        UserDefaults.standard.set(currentCount+1, forKey:"launchCount")
        
        validateReceipt()
        
        migrateRealm()
        
        classArray = realm.objects(Course.self).filter("realmWillDelete == false")
        
        reminders = realm.objects(Reminder.self).filter("completed == false")
        
        completedReminderes = realm.objects(Reminder.self).filter("completed == true")
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        try! realm.write {
            realm.delete(realm.objects(Course.self).filter("realmWillDelete == true"))
        }
        
        let navigationBarAppearace = UINavigationBar.appearance()

        navigationBarAppearace.tintColor = .systemOrange
        if #available(iOS 13.0, *) {
            navigationBarAppearace.barTintColor = .secondarySystemGroupedBackground
        } else {
            navigationBarAppearace.barTintColor = UIColor.white
            // Fallback on earlier versions
        }

        // change navigation item title color
        if #available(iOS 13.0, *) {
            navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.secondaryLabel]
        } else {
            navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.darkGray]
            // Fallback on earlier versions
        }
        
        if #available(iOS 13.0, *) {
            ProgressHUD.statusColor(.label)
        }
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
    func deleteClasses(){
        loadClasses()
        
        if oldClassArray.count > 0{
        for i in 0...oldClassArray.count-1{
           try! realm.write {
                realm.add(oldClassArray[i])
                print(oldClassArray[i].name)
            }
        }
        }
        if oldReminders.count > 0{
            for i in 0...oldReminders.count-1{
                try! realm.write {
                    realm.add(oldReminders[i])
                }
            }
        }
        if oldCompleted.count > 0{
            for i in 0...oldCompleted.count-1{
                try! realm.write {
                    realm.add(oldCompleted[i])
                }
            }
        }
        do {
            try FileManager.default.removeItem(at: dataFilePath!)
        } catch let error as NSError {
            print("No file found :Error: \(error.domain)")
        }
        
        do {
            try FileManager.default.removeItem(at: remindersDataFilePath!)
        } catch let error as NSError {
            print("No file found :Error: \(error.domain)")
        }
        
        do {
            try FileManager.default.removeItem(at: completedDataFilePath!)
        } catch let error as NSError {
            print("Error: \(error.domain)")
        }
        

    }
    func loadClasses(){
        if let data =  try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                try  oldClassArray = decoder.decode([Course].self, from: data)
            }
            catch{
                print("error loading items \(error)")
            }
        }
        
        if let data =  try? Data(contentsOf: remindersDataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                try  oldReminders = decoder.decode([Reminder].self, from: data)
                
            }
            catch{
                print("error loading items \(error)")
            }
        }
        
        if let data =  try? Data(contentsOf: completedDataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                try  oldCompleted = decoder.decode([Reminder].self, from: data)
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
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let encoder = PropertyListEncoder()
        
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
    func migrateRealm(){
        // Inside your application(application:didFinishLaunchingWithOptions:)
        
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 8,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    self.deleteClasses()
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
    }
    func scheduleLocal(remind: Reminder){
        if(remind.willNotify && !remind.completed){
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = NotificationPhrases().getPhrase()
            
            if let test = remind.course{
            if test.name != Course().name && test.name != "No class"{
            content.body = "\(remind.name) for \(test.name)"
            }else{
             content.body = remind.name
                }
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
    
    func validateReceipt(){
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "b362e56bde814ae09d11f0016a046131")
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productIds = Set([ "premium.monthly",
                                       "gradePointPremium"])
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(productIds: productIds, inReceipt: receipt)
                var isVerified = false
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    let save = UserDefaults.standard
                    save.set(true, forKey: "Purchase")
                    isVerified = true
                    print("\(productIds) are valid until \(expiryDate)\n\(items)\n")
                case .expired(let expiryDate, let items):
                    if !isVerified{
                        let save = UserDefaults.standard
                        save.set(nil, forKey: "Purchase")
                    }
                    print("\(productIds) are expired since \(expiryDate)\n\(items)\n")
                case .notPurchased:
                    if !isVerified{
                        let save = UserDefaults.standard
                        save.set(nil, forKey: "Purchase")
                        print("The user has never purchased \(productIds)")
                    }
                }
            case .error(let error):
                print("Receipt verification failed: \(error)")
                
            }
        }
    }

}


