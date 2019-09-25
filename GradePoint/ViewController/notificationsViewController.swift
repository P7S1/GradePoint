//
//  notificationsViewController.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 8/6/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//
import SKPhotoBrowser
import DJSemiModalViewController
import UIKit
import UserNotifications
import RealmSwift
import GoogleMobileAds
import SwiftEntryKit

var editingIndexPath : IndexPath = IndexPath.init()
var completedReminderes : Results<Reminder>!
var userNotificationsEnabled = false

let remindersDataFilePath = FileManager.default.urls(for: .documentDirectory,in:.userDomainMask).first?.appendingPathComponent("Reminders.plist")

let completedDataFilePath = FileManager.default.urls(for: .documentDirectory,in:.userDomainMask).first?.appendingPathComponent("completedReminders.plist")


class notificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var reminderOutlet: UITableView!
    
    @IBOutlet weak var bannerView: GADBannerView!
    

    @IBOutlet weak var isHidden: UILabel!
    
    var vc : UIViewController!
    
    var globalController = DJSemiModalViewController()
    
    @IBOutlet weak var sectionView: UIView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showAds()
        
        isHidden.isHidden = reminders.count == 0 || completedReminderes.count == 0
        
        NotificationCenter.default.addObserver(self, selector: #selector( loadList), name:NSNotification.Name(rawValue: "edit"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(presentNotification), name:NSNotification.Name(rawValue: "presentNotification"), object: nil)
        
     vc = self.storyboard?.instantiateViewController(withIdentifier: "calendarViewController") as! bigCalendarViewController
        
        reminderOutlet.delegate = self
        reminderOutlet.dataSource = self
    
        
        NotificationCenter.default.addObserver(self, selector: #selector(unDimScreen), name:NSNotification.Name(rawValue: "unDimScreen"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadReminders), name:NSNotification.Name(rawValue: "loadReminders"), object: nil)
        print("notifiacaitons view controller")
        
        
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "icons8-plus-100.png"), for: UIControl.State.normal)
        button.addTarget(self, action:#selector(addNotificationPressed), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navItem.rightBarButtonItem = barButton
        
        self.navBar.isTranslucent = false
        
       self.navItem.title = "Assignments"
        reminderOutlet.allowsSelection = true
        
        
                // Do any additional setup after loading the view.
    }
    
    func showAds(){
        let save = UserDefaults.standard
        if save.value(forKey: "Purchase") == nil{
            
            bannerView.adUnitID = "ca-app-pub-7404153809143887/3551717727"
            
            bannerView.rootViewController = self
            
            
            print("User is NOT Premium, will show ads")
        }else{
            bannerView.isHidden = true
            print("User is Premium, won't show ads")
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        if reminders.count == 0 && completedReminderes.count == 0{
            reminderOutlet.reloadData()
        }
        
        isHidden.isHidden = reminders.count != 0 || completedReminderes.count != 0
        print(reminders.count != 0 && completedReminderes.count != 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath) as! remindersTableViewCell
        
        var cellReminder = Reminder()
        if(indexPath.section==0){
            cellReminder = reminders[indexPath.row]
        }
        else{
            cellReminder = completedReminderes[indexPath.row]
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM dd")
        var stringDate = dateFormatter.string(from: cellReminder.due as Date)
        stringDate = "Due: \(stringDate)"
        
        
        cell.name.text = cellReminder.name
        cell.dueDate.text = stringDate
        
        cell.notificationImage.isHidden = !cellReminder.willNotify
        cell.notificationImage.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        
         let isHidden = cellReminder.image == nil
          cell.hasAttachment.isHidden = isHidden
        
        cell.hasAttachment.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        
        if cellReminder.completed{
            cell.completedText.text = "Completed"
            cell.completedText.textColor = .systemGreen
        }
        else{
            cell.completedText.text = "Not Completed"
            cell.completedText.textColor = .systemRed
        }
        if let test = cellReminder.course{
            cell.className.text = test.name
        }else{
            cell.className.text = "No class"
        }
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
       return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reminders.count == 0 && completedReminderes.count == 0{
            tableView.setEmptyView(title: "No Assignments", message: "Press the orange plus at the top right to add some")
        }else{
            tableView.restore()
        }
        if(section == 0)
        {
        return reminders.count
        }
        else{
            return completedReminderes.count
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            if(indexPath.section == 0){
                try! realm.write {
                 realm.delete(reminders[indexPath.row])
                }
            }
            else{
                try! realm.write {
                    realm.delete(completedReminderes[indexPath.row])
                }
            }
            reminderOutlet.deleteRows(at: [indexPath], with: .automatic)
            
                    isHidden.isHidden = reminders.count != 0 || completedReminderes.count != 0
        }
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var edit = UIContextualAction()
        if indexPath.section == 0 {
        //Complete
         edit = UIContextualAction(style:.normal, title: nil) { (action, view, completionHandler) in

            
            try! realm.write {
            let newReminder = Reminder()
            newReminder.match(remind: reminders[indexPath.row])
            realm.delete(reminders[indexPath.row])
            newReminder.completed = true
            realm.add(newReminder)
            }
            print(reminders!)
            print(completedReminderes!)

            self.reminderOutlet.reloadData()
            
            completionHandler(true)
            
            ProgressHUD.showSuccess("Completed")
            
        }
            edit.backgroundColor = .systemGreen
        edit.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
            UIImage(named: "complete")?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
        }

        }else{
            //decomplete
             edit = UIContextualAction(style:.normal, title: nil) { (action, view, completionHandler) in
        
                ProgressHUD.showError("Uncomplete")
                try! realm.write {
                    let newReminder = Reminder()
                    newReminder.match(remind: completedReminderes[indexPath.row])
                    realm.delete(completedReminderes[indexPath.row])
                    newReminder.completed = false
                    realm.add(newReminder)
                }
                
                self.reminderOutlet.reloadData()
                
                completionHandler(true)
                
            }
            
            edit.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.137254902, blue: 0.2941176471, alpha: 1)
            edit.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
                UIImage(named: "whiteDelete")?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
            }
        }
        let edit2 = UIContextualAction(style: .normal, title: nil) { (action, view, completionHandler) in
            editingIndexPath = indexPath
            userIsEditing = true
            self.performSegue(withIdentifier: "goToCreateReminder", sender: self)
            completionHandler(true)
            print("user is editing a cell")
        }
        edit2.backgroundColor = .systemOrange
        edit2.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
            UIImage(named: "edit")?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
        }
        return UISwipeActionsConfiguration(actions: [edit2,edit])
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
         
        
             headerView.backgroundColor = .clear
         

         let label = UILabel()
         label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
         if section == 0{
          label.text = "ONGOING"
         }else if section == 1{
             label.text = "COMPLETED"
         }
         label.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
         if #available(iOS 13.0, *) {
             label.textColor = .darkGray
         } else {
             label.textColor = .darkGray
             // Fallback on earlier versions
         } // my custom colour

         headerView.addSubview(label)

         return headerView
    }
    

    @IBAction func switchAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            print("notifications")
            vc.view.removeFromSuperview()
            isHidden.isHidden = reminders.count != 0 || completedReminderes.count != 0
            break
        case 1:
            print("Calender view")
            isHidden.isHidden = true
            vc.view.frame = sectionView.bounds
            sectionView.addSubview(vc.view)
            break
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        editingIndexPath = indexPath
        presentNotificationAtEditingIndex()
        
    }
    func presentNotificationAtEditingIndex(){
        // Create a basic toast that appears at the top
        var attributes = EKAttributes.bottomFloat
        
        attributes.entryInteraction = .absorbTouches
        attributes.screenInteraction = .dismiss
        
        attributes.displayDuration = .infinity

        // Set its background to white
        attributes.entryBackground = .color(color: .standardBackground)
        
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .easeOut)
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
    
        attributes.screenBackground = .color(color: EKColor(UIColor(white: 0.0, alpha: 0.5)))
        
        attributes.roundCorners = .all(radius: 14)

        // Animate in and out using default translation
        attributes.entranceAnimation = .translation
        attributes.exitAnimation = .translation
        let selectView = self.storyboard?.instantiateViewController(withIdentifier: "selectNotificationViewController") as! selectNotificationViewController
        /*
        ... Customize the view as you like ...
        */
        let widthConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.9)
        let heightConstraint = EKAttributes.PositionConstraints.Edge.intrinsic
        attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint)
        // Display the view with the configuration
        SwiftEntryKit.display(entry: selectView, using: attributes)
    }
    @objc func addNotificationPressed(){
        self.performSegue(withIdentifier: "goToCreateReminder", sender: self)
        print("add notification pressed")
    }
    @objc func unDimScreen(){
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1
        }

    }
    @objc func loadReminders(){
        
        isHidden.isHidden = reminders.count != 0 || completedReminderes.count != 0
        
        let indexPath = IndexPath(row: reminders.count-1, section:0)
        reminderOutlet.beginUpdates()
        reminderOutlet.insertRows(at: [indexPath], with: .automatic)
        reminderOutlet.endUpdates()
    }
    @objc func loadList(){
        
        isHidden.isHidden = reminders.count != 0 || completedReminderes.count != 0
        
        if userIsEditing{
            userIsEditing = false
            reminderOutlet.beginUpdates()
            reminderOutlet.deleteRows(at: [editingIndexPath], with: .automatic)
            reminderOutlet.insertRows(at: [editingIndexPath], with: .automatic)
            reminderOutlet.endUpdates()
        }
    }
    @objc func presentNotification(){
        presentNotificationAtEditingIndex()
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
