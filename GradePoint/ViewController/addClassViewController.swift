//
//  addClassViewController.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 7/15/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//
import UIKit
import UserNotifications
import RealmSwift
var weights : CourseWeights = CourseWeights()
var classArray : Results<Course>!
var realm = try! Realm()
var editingIndex = 0
var userIsEditing = false
var userTappedOut = false
let dataFilePath = FileManager.default.urls(for: .documentDirectory,in:.userDomainMask).first?.appendingPathComponent("Course.plist")
let defaults = UserDefaults.standard

class addClassViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate{
    
    
    var globalGPA = 0.000
    var globalUnweightedGPA = 0.000
    
    @IBOutlet weak var classOutlet: UITableView!
    
    @IBOutlet weak var gpaText: UILabel!
    @IBOutlet weak var unweightedGPAText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewWillAppear(true)
        
        
        classOutlet.delegate = self
        classOutlet.dataSource = self
        classOutlet.allowsSelection = true
        NotificationCenter.default.addObserver(self, selector: #selector( loadList), name:NSNotification.Name(rawValue: "load"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(unDimScreen), name:NSNotification.Name(rawValue: "unDimScreen"), object: nil)

        
        
       reloadData()
        
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        //launches promo only once
        
        
        AppStoreReviewManager.requestReviewIfAppropriate()
        
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        let save = UserDefaults.standard
        if save.value(forKey: "Purchase") == nil && !launchedBefore{
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "premiumVIewController") as! premiumViewController)
            let vc1 = (self.storyboard?.instantiateViewController(withIdentifier: "walkthroughViewController") as! walkthroughViewController)
            self.present(vc, animated: true){
                vc.present(vc1, animated: true, completion: nil)
            }
        }
        if classArray.count == 0{
        classOutlet.reloadData()
        }
        calculateGPA()
    }
    //TODO: Share functionality
    @IBAction func shareButton(_ sender: Any) {
        let activityController = UIActivityViewController(activityItems: ["I got a weighted gpa of \(String(format: "%.3f", globalGPA)) and \(String(format: "%.3f", globalUnweightedGPA)) unweighted! I calculated it using the gpa app. Check it out here: https://itunes.apple.com/us/app/gradepoint/id1477275391?ls=1&mt=8"], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view
        
        present(activityController, animated: true, completion: nil)
    }
    //TODO: ADD CLASS PRESSED
    @IBAction func addClassPressed(_ sender: Any) {
        dimScreen()
        userIsEditing = false
    }
    //TODO: TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if classArray.isEmpty{
            tableView.setEmptyView(title: "You Have No Classes", message: "Press the gray plus in the bottom to add some!")
        }else{
            tableView.restore()
        }
        return classArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classCell", for: indexPath) as! classesTableViewCell
        print("new tableview cell added")
        cell.class_Name.text = classArray[indexPath.row].name
        cell.class_Grade.text = classArray[indexPath.row].grade
        cell.class_Grade.textColor = classArray[indexPath.row].getGradeColor()
        cell.class_Weight.text = classArray[indexPath.row].weight
        cell.class_credit.text = "\(classArray[indexPath.row].credits) credits"
        
        if classArray[indexPath.row].exempt{
           let attributedText = NSMutableAttributedString(string: classArray[indexPath.row].name)
            attributedText.addAttributes([
                NSAttributedString.Key.strikethroughStyle:NSUnderlineStyle.single.rawValue, NSAttributedString.Key.strikethroughColor:UIColor.black],
                                         range: NSMakeRange(0, attributedText.length))
            
            cell.class_Name.attributedText = attributedText
            
            cell.class_Grade.text = "--"
            cell.class_Grade.textColor = UIColor.lightGray
        }
        
        print("added to table")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.3)
        {
            cell.alpha = 1.0
        }
    }
    //TODO: DELETING ROWS FUNCTIONALITY
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editingIndexPath = indexPath
        self.performSegue(withIdentifier: "goToCalculateGrade", sender: self)
        classOutlet.deselectRow(at: indexPath, animated: true)
    }
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete
        {
            try! realm.write {
            realm.delete(classArray[indexPath.row])
            }
            classOutlet.deleteRows(at: [indexPath], with: .automatic)
            calculateGPA()
        }
} 
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //EDIT
        let edit = UIContextualAction(style:.normal, title: nil) { (action, view, completionHandler) in
            print("User swiped to edit cell")
            userIsEditing = true
            editingIndex = indexPath.row
            print("sending user to editing screen with index of \(indexPath.row)")
            self.dimScreen()
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "createView") as! createClassViewController
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
        let calc = UIContextualAction(style:.normal, title: nil) { (action, view, completionHandler) in
            editingIndexPath = indexPath
            self.performSegue(withIdentifier: "goToCalculateGrade", sender: self)
        }
        calc.backgroundColor = .systemGreen
        edit.backgroundColor = .systemOrange
        calc.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
            UIImage(named: "calc")?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
        }
        edit.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
            UIImage(named: "edit")?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
        }
        return UISwipeActionsConfiguration(actions: [edit,calc])
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
          label.text = "CLASSES"
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
    //TODO: CALCULATE GPA
    func calculateGPA(){
        var points = 0.0
        var creditsSum = 0.0
        var unweightedPoints = 0.0
        var gpa = 0.0
        var unweightedGpa = 0.0
        let runtime = classArray.count-1
        if classArray.count > 0{
        for i in 0...runtime{
            if classArray[i].exempt{
                print("\(classArray[i].name)class was exempt")
            }else{
            points = points +  (weights.getWeight(course: classArray[i]) * classArray[i].credits)
           // points = points +  (classArray[i].getValue() * classArray[i].credits)
            let previousWeight = classArray[i].weight
                try! realm.write {
                classArray[i].weight = "Regular"
                }
            unweightedPoints = unweightedPoints + (CourseWeights().getWeight(course: classArray[i]) * classArray[i].credits)
            creditsSum = creditsSum + classArray[i].credits
                try! realm.write {
                classArray[i].weight = previousWeight
                }
            }
        }
        gpa = points / creditsSum
        unweightedGpa = unweightedPoints/creditsSum
            
            globalGPA = gpa
            globalUnweightedGPA = unweightedGpa
            unweightedGPAText.text = "\(String(format: "%.3f", unweightedGpa)) Unweighted"
            gpaText.text = String(format: "%.3f", gpa)
            
            if gpa.isNaN && unweightedGpa.isNaN{
                unweightedGPAText.text = "0.000 Unweighted"
                gpaText.text = "0.000"
            }
        }else{
            unweightedGPAText.text = "0.000 Unweighted"
            gpaText.text = "0.000"
        }
    }
    //TODO: RELOAD ALL DATA
    func reloadData(){
        classOutlet.reloadData()
        calculateGPA()
    }
    @objc func unDimScreen(){
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1
        }
    }
    func dimScreen(){
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 0.5
        }
        
    }
    @objc func loadList(notification: NSNotification){
        //load data here
        if(userTappedOut)
        {
            unDimScreen()
            userTappedOut = false
        }else{
        if(userIsEditing){
            classOutlet.reloadData()
            userIsEditing = false
        }
        else{
        let indexPath = IndexPath(row: classArray.count-1, section:0)
        classOutlet.beginUpdates()
        classOutlet.insertRows(at: [indexPath], with: .automatic)
        classOutlet.endUpdates()
        }
        unDimScreen()
        calculateGPA()
        }
        
    }

}


