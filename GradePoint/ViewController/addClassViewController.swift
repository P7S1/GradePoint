//
//  addClassViewController.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 7/15/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//

import UIKit
var classArray : [Course] = [Course]()
var editingIndex = 0
var userIsEditing = false
var userTappedOut = false
var globalGPA = 0.000
var globalUnweightedGPA = 0.000
let dataFilePath = FileManager.default.urls(for: .documentDirectory,in:.userDomainMask).first?.appendingPathComponent("Course.plist")


class addClassViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate{
    
    
    @IBOutlet weak var classOutlet: UITableView!
    
    @IBOutlet weak var gpaText: UILabel!
    @IBOutlet weak var unweightedGPAText: UILabel!
    
    @IBOutlet weak var addClassButton: UIButton!
    
    let transition = SlideInTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewWillAppear(true)
        classOutlet.delegate = self
        classOutlet.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector( loadList), name:NSNotification.Name(rawValue: "load"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(presentHIW), name:NSNotification.Name(rawValue: "presentHIW"), object: nil)

       styleView()
       reloadData()
        
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    }
    //TODO: Share functionality
    @IBAction func shareButton(_ sender: Any) {
        let activityController = UIActivityViewController(activityItems: ["I got a weighted gpa of \(String(format: "%.3f", globalGPA)) and \(String(format: "%.3f", globalUnweightedGPA)) unweighted! I calculated it using the gpa app. Check it out here:"], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    //TODO: ADD CLASS PRESSED
    @IBAction func addClassPressed(_ sender: Any) {
        dimScreen()
        userIsEditing = false
    }
    //TODO: TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        print("added to table")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        cell.backgroundColor = UIColor.clear
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
        classOutlet.deselectRow(at: indexPath, animated: false)
    }
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete
        {
            classArray.remove(at:indexPath.row)
            classOutlet.deleteRows(at: [indexPath], with: .automatic)
            calculateGPA()
        }
        if editingStyle == .none {
            userIsEditing = true
            print("sending user to editing screen with index of \(editingIndex)")
            performSegue(withIdentifier: "editScreen", sender: self)    
        }
} /*
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeAction = UISwipeActionsConfiguration(actions: [])
        
        return swipeAction
    } */
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //EDIT
        let edit = UIContextualAction(style:.normal, title: "Edit") { (action, view, completionHandler) in
            print("User swiped to edit cell")
            userIsEditing = true
            editingIndex = indexPath.row
            print("sending user to editing screen with index of \(indexPath.row)")
            self.dimScreen()
            self.performSegue(withIdentifier: "editScreen", sender: self)
            self.classOutlet.setEditing(false, animated: true)
        }
        edit.backgroundColor = #colorLiteral(red: 1, green: 0.662745098, blue: 0.07843137255, alpha: 1)
        edit.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
            UIImage(named: "edit")?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
        }
        /* DELETE
        let delete = UIContextualAction(style:.normal, title: "Delete") { (action, view, completionHandler) in
            print("User deleted item")
            self.self.classOutlet.beginUpdates()
            self.classOutlet.deleteRows(at: [indexPath], with: .automatic)
            classArray.remove(at:indexPath.row)
            self.classOutlet.endUpdates()
            self.calculateGPA()
            self.classOutlet.setEditing(false, animated: true)
        }
        delete.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.1921568627, blue: 0.1490196078, alpha: 1)
        delete.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
            UIImage(named: "delete")?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
        }
        */
        return UISwipeActionsConfiguration(actions: [edit])
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
            points = points +  (classArray[i].getValue() * classArray[i].credits)
            let previousWeight = classArray[i].weight
            classArray[i].weight = "Regular"
            unweightedPoints = unweightedPoints + (classArray[i].getValue() * classArray[i].credits)
            creditsSum = creditsSum + classArray[i].credits
            classArray[i].weight = previousWeight
        }
        gpa = points / creditsSum
        unweightedGpa = unweightedPoints/creditsSum
            globalGPA = gpa
            globalUnweightedGPA = unweightedGpa
            unweightedGPAText.text = "\(String(format: "%.3f", unweightedGpa)) Unweighted"
            gpaText.text = String(format: "%.3f", gpa)
        }else{
            unweightedGPAText.text = "0.000 Unweighted"
            gpaText.text = "0.000"
        }
    }
    //TODO: RELOAD ALL DATA
    func reloadData(){
        classOutlet.rowHeight = UITableView.automaticDimension
        classOutlet.estimatedRowHeight = 200.0
        classOutlet.reloadData()
        classOutlet.separatorStyle = .none
        calculateGPA()
    }
    func styleView(){
        addClassButton.layer.cornerRadius = 10
        addClassButton.clipsToBounds = true
        
        
    }
    func unDimScreen(){
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1
        }
    }
    func dimScreen(){
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 0.5
        }
        
    }
    @IBAction func didSelectMenu(_ sender: Any) {
 
        guard let settingsViewController = storyboard?.instantiateViewController(withIdentifier:"MenuViewController") else{
            return
        }
        settingsViewController.modalPresentationStyle = .overCurrentContext
        settingsViewController.transitioningDelegate = self
        present(settingsViewController, animated:true)
    }
    @objc func loadList(notification: NSNotification){
        //load data here
        if(userTappedOut)
        {
            unDimScreen()
            userTappedOut = false
        }else{
        if(userIsEditing){
            let indexPath = IndexPath(row: editingIndex, section:0)
            classOutlet.beginUpdates()
            classOutlet.deleteRows(at: [indexPath], with: .automatic)
            classOutlet.insertRows(at: [indexPath], with: .automatic)
            classOutlet.endUpdates()
            userIsEditing = false
        }
        else{
        let indexPath = IndexPath(row: classArray.count-1, section:0)
        classOutlet.beginUpdates()
        classOutlet.insertRows(at: [indexPath], with: .automatic)
        classOutlet.endUpdates()
        }
        unDimScreen()
        classOutlet.layer.cornerRadius = 10
        classOutlet.layer.masksToBounds = true
        calculateGPA()
        }
        
    }
    
    @objc func presentHIW(){
        if(menuIndex == 0)
        {
        print("Menu index 2")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "howItWorksView") as! howItWorksViewController
        self.present(vc, animated: true, completion: nil)
        }else if(menuIndex == 1){
            print("MENU INDEX 1")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "privacyPolicyView") as! privacyPolicyViewController
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
        else{
            print("Menu index 3")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "aboutView") as! aboutViewController
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
            
        }
    }

}

extension addClassViewController: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
    
}
