//
//  notificationsViewController.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 8/6/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//
import DJSemiModalViewController
import UIKit
import UserNotifications

import GoogleMobileAds

var editingIndexPath : IndexPath = IndexPath.init()
var completedReminderes : [Reminder] = [Reminder]()
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
    
    @IBOutlet weak var sectionView: UIView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        isHidden.isHidden = reminders.count == 0 || completedReminderes.count == 0
        
        
        bannerView.adUnitID = "ca-app-pub-7404153809143887/3551717727"
        //ca-app-pub-7404153809143887/3551717727
        bannerView.rootViewController = self
        
        NotificationCenter.default.addObserver(self, selector: #selector( loadList), name:NSNotification.Name(rawValue: "edit"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(presentNotification), name:NSNotification.Name(rawValue: "presentNotification"), object: nil)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (didAllow, error) in
            userNotificationsEnabled = didAllow
            if !userNotificationsEnabled && error != nil{
                print(error!)
            }
        }
        
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
        
        
                // Do any additional setup after loading the view.
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
        
        if cellReminder.completed{
            cell.completedText.text = "Completed"
            cell.completedText.textColor = #colorLiteral(red: 0.2352941176, green: 1, blue: 0.3333333333, alpha: 1)
        }
        else{
            cell.completedText.text = "Not Completed"
            cell.completedText.textColor = #colorLiteral(red: 1, green: 0.3098039216, blue: 0.2666666667, alpha: 1)
        }
        cell.className.text = cellReminder.course.name
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
       return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            reminders.remove(at:indexPath.row)
            }
            else{
            completedReminderes.remove(at:indexPath.row)
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
            reminders[indexPath.row].completed = true
            completedReminderes.append(reminders[indexPath.row])
            
            let newIndexPath = IndexPath(row: completedReminderes.count-1, section: 1)
            
            
            reminders.remove(at:indexPath.row)
            self.reminderOutlet.beginUpdates()
            self.reminderOutlet.insertRows(at: [newIndexPath], with: .automatic)
            self.reminderOutlet.deleteRows(at: [indexPath], with: .automatic)
            self.reminderOutlet.endUpdates()
            
            completionHandler(true)
            
            ProgressHUD.showSuccess("Completed")
            
            print("User swiped complete a cell")
        }
        edit.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.7647058824, blue: 0.2156862745, alpha: 1)
        edit.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
            UIImage(named: "complete")?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
        }

        }else{
            //decomplete
             edit = UIContextualAction(style:.normal, title: nil) { (action, view, completionHandler) in
        
                ProgressHUD.showError("Uncomplete")
                
                completedReminderes[indexPath.row].completed = false
                reminders.append(completedReminderes[indexPath.row])
                
                
                let newIndexPath = IndexPath(row: reminders.count-1, section: 0)
                
                
                completedReminderes.remove(at:indexPath.row)
                self.reminderOutlet.beginUpdates()
                self.reminderOutlet.insertRows(at: [newIndexPath], with: .automatic)
                self.reminderOutlet.deleteRows(at: [indexPath], with: .automatic)
                self.reminderOutlet.endUpdates()
                
                completionHandler(true)
                
                print("User swiped to de complete a cell")
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
        edit2.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.5450980392, blue: 0, alpha: 1)
        edit2.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
            UIImage(named: "edit")?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
        }
        return UISwipeActionsConfiguration(actions: [edit2,edit])
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupHeader") as! headerViewCell
        if(section == 0)
        {
        cell.headerText.text = "Ongoing"
        }else{
        cell.headerText.text = "Completed"
        }
        return cell.contentView
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
        
            let controller = DJSemiModalViewController()
        tableView.deselectRow(at: indexPath, animated: true)
        
        editingIndexPath = indexPath
        
        var reminder : Reminder
        
        if(indexPath.section == 0){
            reminder = reminders[indexPath.row]
        }
        else{
            reminder = completedReminderes[indexPath.row]
        }
        controller.title = reminder.name
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 400))
        label.numberOfLines = 4
        //due date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM dd, yyyy")
        var stringDate = dateFormatter.string(from: reminder.due as Date)
        stringDate = "Due \(stringDate)"
        //reminder date
        var stringTime = ""
        
        if(reminder.willNotify)
        {
            dateFormatter.setLocalizedDateFormatFromTemplate("h:mm a MMMM dd")
            stringTime = dateFormatter.string(from: reminder.reminder as Date)
            stringTime = "Will remind on \(stringTime)"
            
        }else{
            stringTime = "No reminders"
        }
        //name
        var stringName = ""
        stringName = reminder.course.name
        
        //completed
        var stringCompleted = ""
        if reminder.completed{
            stringCompleted = "Completed"
        }else{
            stringCompleted = "Not completed"
        }
        
        let ray = [stringDate,stringTime,stringName,stringCompleted]
        
        var myString = ray[0]
        for i in 1...ray.count-1{
            myString = "\(myString)\n\(ray[i])"
        }
        
        myString = "\(myString)\n \(reminder.notes)"
        
        let output = NSMutableAttributedString(string: myString)

        print(ray)
        
        controller.titleLabel.font = UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.heavy)
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = 16
        
        let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.darkGray ]
        
        let myAttribute2 = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)]
        
        output.addAttributes(myAttribute, range: NSMakeRange(0, output.length))
        
        output.addAttributes(myAttribute2, range: NSMakeRange(0, output.length))
        
        output.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, output.length))
        
        label.numberOfLines = 5
        label.attributedText = output
        label.textAlignment = .center
        controller.addArrangedSubview(view: label)
        
        controller.presentOn(presentingViewController: self, animated: true, onDismiss: { })
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
        
        
        print("presenting notifications at \(editingIndexPath)")
        let controller = DJSemiModalViewController()
        
        var reminder = Reminder()
        
        if editingIndexPath.section == 0 && reminders.count > 0{
        reminder = reminders[editingIndexPath.row]
        }else if editingIndexPath.section == 1 && completedReminderes.count > 0{
        reminder = completedReminderes[editingIndexPath.row]
        }
        
        controller.title = reminder.name
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 400))
        label.numberOfLines = 4
        //due date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM dd, yyyy")
        var stringDate = dateFormatter.string(from: reminder.due as Date)
        stringDate = "Due \(stringDate)"
        //reminder date
        var stringTime = ""
        
        if(reminder.willNotify)
        {
            dateFormatter.setLocalizedDateFormatFromTemplate("h:mm a MMMM dd")
            stringTime = dateFormatter.string(from: reminder.reminder as Date)
            stringTime = "Will remind on \(stringTime)"
            
        }else{
            stringTime = "No reminders"
        }
        //name
        var stringName = ""
        stringName = reminder.course.name
        
        //completed
        var stringCompleted = ""
        if reminder.completed{
            stringCompleted = "Completed"
        }else{
            stringCompleted = "Not completed"
        }
        
        let ray = [stringDate,stringTime,stringName,stringCompleted]
        
        var myString = ray[0]
        for i in 1...ray.count-1{
            myString = "\(myString)\n\(ray[i])"
        }
        myString = "\(myString)\n \(reminder.notes)"
        
        let output = NSMutableAttributedString(string: myString)
        
        print(ray)
        
        controller.titleLabel.font = UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.heavy)
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = 16
        
        let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.darkGray ]
        
        let myAttribute2 = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)]
        
        output.addAttributes(myAttribute, range: NSMakeRange(0, output.length))
        
        output.addAttributes(myAttribute2, range: NSMakeRange(0, output.length))
        
        output.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, output.length))
        
        label.numberOfLines = 5
        label.attributedText = output
        label.textAlignment = .center
        controller.addArrangedSubview(view: label)
        
        controller.presentOn(presentingViewController: self, animated: true, onDismiss: { })
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
