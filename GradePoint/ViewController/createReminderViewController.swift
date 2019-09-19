//
//  createReminderViewController.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 8/9/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import Eureka
import GoogleMobileAds
import RealmSwift
import ImageRow
var reminders : Results<Reminder>!
var adCount = 0
class createReminderViewController: FormViewController, GADInterstitialDelegate {
    
    
    
    var classString : [String]  = [String]()
    
        var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-7404153809143887/4126432796")
        //ca-app-pub-3940256099942544/4411468910
        let request = GADRequest()
        interstitial.load(request)
        
            interstitial.delegate = self
        
        let rightButtonItem = UIBarButtonItem.init(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(exitPressed)
        )
        rightButtonItem.tintColor = #colorLiteral(red: 1, green: 0.662745098, blue: 0.07843137255, alpha: 1)
        
        let leftButtonItem = UIBarButtonItem.init(
            title: "Cancel",
            style: .done,
            target: self,
            action: #selector(dismissScreen)
        )
        leftButtonItem.tintColor = #colorLiteral(red: 1, green: 0.662745098, blue: 0.07843137255, alpha: 1)
        
        if userIsEditing{
        navigationItem.title = "Edit Assignment"
        }
        else{
        navigationItem.title = "New Assignment"
        }
        
        self.navigationItem.setRightBarButtonItems([rightButtonItem], animated: true)
        self.navigationItem.setLeftBarButtonItems([leftButtonItem], animated: true)

        
        classString = ["none"]
        if(classArray.count > 0){
        for i in 0...classArray.count-1{
            classString.append(classArray[i].name)
        }
        }
        
        //name
        form +++ Section("Assignment")
            <<< TextRow(){ row in
                if userIsEditing && editingIndexPath.section == 0{
                    row.value = reminders[editingIndexPath.row].name
                }else if userIsEditing && editingIndexPath.section == 1{
                    row.value = completedReminderes[editingIndexPath.row].name
                }
                
                row.validationOptions = .validatesOnChange
                row.tag = "name"
                row.title = "Description"
                row.placeholder = "Enter decription of assignment here"
                row.cellUpdate { (cell, row) in
                    if #available(iOS 13.0, *) {
                        cell.titleLabel?.textColor = .label
                        cell.textField.textColor = .label
                    } else {
                        cell.titleLabel?.textColor = .black
                        cell.textField.textColor = .black
                        // Fallback on earlier versions
                    }
                }
                }
        //due date
        form +++ Section("Due Date")
            <<< DateRow(){
                if userIsEditing && editingIndexPath.section == 0{
                    $0.value = reminders[editingIndexPath.row].due
                }else if userIsEditing && editingIndexPath.section == 1{
                    $0.value = completedReminderes[editingIndexPath.row].due
                }
                $0.tag = "dueDate"
                $0.title = "Due"
                $0.cellUpdate { (cell, row) in
                    if #available(iOS 13.0, *) {
                        cell.textLabel?.textColor = .label
                    } else {
                        cell.textLabel?.textColor = .black
                        // Fallback on earlier versions
                    }
                }

                }.onCellSelection({ (cell, row) in
                    if row.value == nil {
                        row.value = Date()// Set default value.
                    }
                })
        form +++ Section("Select a class")
            <<< ActionSheetRow<String>() {
                $0.tag = "class"
                $0.title = "Class"
                $0.selectorTitle = "Your classes"
                $0.options = classString
                if userIsEditing && editingIndexPath.section == 0{
                    if let test = reminders[editingIndexPath.row].course{
                    $0.value = test.name
                    }
                    else{
                        $0.value = "No Class"
                    }
                }
                else if userIsEditing && editingIndexPath.section == 1{
                    if let test = completedReminderes[editingIndexPath.row].course{
                        $0.value = test.name
                    }
                }
                else{
                    $0.value = classString[0]    // initially selected
                }
                $0.cellUpdate { (cell, row) in
                    if #available(iOS 13.0, *) {
                        cell.textLabel?.textColor = .label
                    } else {
                        cell.textLabel?.textColor = .black
                        // Fallback on earlier versions
                    }
                }
                }
        form +++ Section("Notify me")
                <<< SwitchRow("switchRowTag"){ row in
                    row.title = "Notifcations enabled"
                    if userIsEditing && editingIndexPath.section == 0{
                        row.value = reminders[editingIndexPath.row].willNotify
                    }else if userIsEditing && editingIndexPath.section == 1{
                        row.value = completedReminderes[editingIndexPath.row].willNotify
                    }
                    row.cellUpdate { (cell, row) in
                        if #available(iOS 13.0, *) {
                            cell.textLabel?.textColor = .label
                        } else {
                            cell.textLabel?.textColor = .black
                            // Fallback on earlier versions
                        }
                    }
                    }.onChange({ (row) in
                        row.title = (row.value ?? false) ? "Remind me at" : "Notify me"
                        row.updateCell()
                    })
            <<< DateTimePickerRow(){
                $0.tag = "reminderDate"
                if userIsEditing && editingIndexPath.section == 0{
                    $0.value = reminders[editingIndexPath.row].reminder
                }
                else if userIsEditing && editingIndexPath.section == 1{
                    $0.value = completedReminderes[editingIndexPath.row].reminder
                }
                else if $0.value == nil {
                    $0.value = Date()// Set default value.
                }
                $0.hidden = Condition.function(["switchRowTag"], { form in
                    return !((form.rowBy(tag: "switchRowTag") as? SwitchRow)?.value ?? false)
                })
                $0.title = "Select Time"
                }
            form +++ Section(header: "Notes", footer: "You can view these easily by tapping on the assignment")
            <<< TextAreaRow(){ row in
                if userIsEditing && editingIndexPath.section == 0{
                    row.value = reminders[editingIndexPath.row].notes
                }else if userIsEditing && editingIndexPath.section == 1{
                    row.value = completedReminderes[editingIndexPath.row].notes
                }
                row.placeholder = "Enter Notes here"
                row.tag = "Notes"
                row.cellUpdate { (cell, row) in
                    if #available(iOS 13.0, *) {
                        cell.textLabel?.textColor = .label
                        cell.textView.textColor = .label
                        cell.placeholderLabel?.textColor = .quaternaryLabel
                        cell.backgroundColor = .systemBackground
                        cell.textView.backgroundColor = .systemBackground
                    } else {
                        cell.textLabel?.textColor = .black
                        cell.textView.textColor = .black
                        // Fallback on earlier versions
                    }
                }
                }.onChange({ (row) in
                    let save = UserDefaults.standard
                    if save.value(forKey: "Purchase") == nil{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "premiumVIewController") as! premiumViewController
                    self.present(vc, animated: true, completion: nil)
                    row.value = ""
                    }
                })
        form +++ Section(header: "Attachment", footer: "You can view these easily by tapping on the assignment")
            <<< ImageRow() { row in
                row.tag = "Attachment"
                row.title = "Photo Notes"
                row.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera]
                row.clearAction = .yes(style: UIAlertAction.Style.destructive)
                if userIsEditing && editingIndexPath.section == 0{
                    if let data = reminders[editingIndexPath.row].image{
                        row.value = UIImage(data: data)
                    }
                }
                else if userIsEditing && editingIndexPath.section == 1{
                    if let data = completedReminderes[editingIndexPath.row].image{
                    row.value = UIImage(data: data)
                    }
                }
                else if row.value == nil {
                    row.value = nil// Set default value.
                }
                row.cellUpdate { (cell, row) in
                    if #available(iOS 13.0, *) {
                        cell.textLabel?.textColor = .label
                        cell.detailTextLabel?.textColor = .label
                    } else {
                        cell.textLabel?.textColor = .black
                        cell.detailTextLabel?.textColor = .black
                        // Fallback on earlier versions
                    }
                }
                
                }.onCellSelection({ (cell, row) in
                    let save = UserDefaults.standard
                    if save.value(forKey: "Purchase") == nil{
                        self.dismiss(animated: true, completion: {
                            self.presentAdView()
                        })
                    }
                }).cellUpdate { cell, row in
                    cell.accessoryView?.layer.cornerRadius = 17
                    cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
                }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        print("view did appear")
    }
    func presentAdView(){
        let save = UserDefaults.standard
        if save.value(forKey: "Purchase") == nil{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "premiumVIewController") as! premiumViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.dismiss(animated: true, completion: nil)
    }
    func createClass(){
        let reminder = Reminder()

        let formvalues = self.form.values()
        
        if let value : String = formvalues["name"] as? String
        {
            print(value)
            reminder.name = value
        }
        if let value : Date = formvalues["dueDate"] as? Date
        {
            print(value)
            reminder.due = value
        }
        if let value : String = formvalues["class"] as? String
        {
            print(value)
            if classArray.count > 0{
            for i in 0...classArray.count-1{
                if classArray[i].name == value{
                    reminder.course = classArray[i]
                    break
                } 
            else{
                    reminder.course = nil
            }
            }
            }
        }
        if let value : Bool = formvalues["switchRowTag"] as? Bool
        {
            print(value)
            reminder.willNotify = value
        }
        if let value : Date = formvalues["reminderDate"] as? Date
        {
            print(value)
            reminder.reminder = value
        }
        if let value : String = formvalues["Notes"] as? String{
            reminder.notes = value
        }
        if let value : UIImage = formvalues["Attachment"] as? UIImage{
            let data = value.jpegData(compressionQuality: 0.25)
            if data != nil{
            reminder.image = data!
            }else{
                reminder.image = nil
            }
        }
        if(userIsEditing){
        if editingIndexPath.section == 0{
            try! realm.write {
                reminders[editingIndexPath.row].name = reminder.name
                reminders[editingIndexPath.row].due = reminder.due
                reminders[editingIndexPath.row].course = reminder.course
                reminders[editingIndexPath.row].willNotify = reminder.willNotify
                reminders[editingIndexPath.row].reminder = reminder.reminder
                reminders[editingIndexPath.row].notes = reminder.notes
                reminders[editingIndexPath.row].image = reminder.image
                
            }
            }
        else{
            try! realm.write {
                completedReminderes[editingIndexPath.row].name = reminder.name
                completedReminderes[editingIndexPath.row].due = reminder.due
                completedReminderes[editingIndexPath.row].course = reminder.course
                completedReminderes[editingIndexPath.row].willNotify = reminder.willNotify
                completedReminderes[editingIndexPath.row].reminder = reminder.reminder
                completedReminderes[editingIndexPath.row].notes = reminder.notes
                completedReminderes[editingIndexPath.row].image = reminder.image
            }
            }
        }else{
            try! realm.write {
                realm.add(reminder)
            }
        }

    }
    func presentAd(){
        let save = UserDefaults.standard
        adCount = adCount + 1
        if interstitial.isReady && adCount % 4 == 0 && save.value(forKey: "Purchase") == nil{
            interstitial.present(fromRootViewController: self)
            print("ad was ready")
        } else {
            print("Ad wasn't ready")
            self.dismiss(animated: true, completion: nil)
        }
    }
    @objc func exitPressed(){
        createClass()
            if userIsEditing{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "edit"), object: nil)
            }else{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadReminders"), object: nil)
            }
        presentAd()
    }
    @objc func dismissScreen(){
        userIsEditing = false

        presentAd()
    }
    @objc func unDimScreen(){
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1
        }
        
        classString = [String]()
        for i in 0...reminders.count-1{
            classString.append(classArray[i].name)
        }
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
extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
}
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
