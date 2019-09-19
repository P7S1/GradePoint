//
//  createClassViewController.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 7/15/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//
import StoreKit
import UIKit
import GoogleMobileAds
import RealmSwift
class createClassViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate, GADInterstitialDelegate{
    @IBOutlet weak var gradePicker: UIPickerView!
    @IBOutlet weak var classTextFieldContent: UITextField!
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var creditStepper: UIStepper!
    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var editSwitch: UISwitch!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var interstitial: GADInterstitial!
    
    var vc = enterPercentViewController()
    
    @IBOutlet weak var sectionView: UIView!
    
    var isPercent = false
    var name = ""
    var credits = 0.5
    var selectedGrade = "A+"
    var selectedWeight = "Regular"
    let grades = ["A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "D-", "F"]
    let weights = ["Regular", "Honors", "AP", "IB SL", "IB HL", "College"]

    
    @IBOutlet weak var createView: UIView!
    
    var calendarView : UIView!
    
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    var initialY: CGFloat = 0.0
    
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vc = self.storyboard?.instantiateViewController(withIdentifier: "enterPercentViewController") as! enterPercentViewController
        
    
        
        initialY = self.view.frame.origin.y
        editSwitch.isOn = false
        if(userIsEditing)
        {
        initClass()
        }
        classTextFieldContent.delegate = self
        styleView()
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        
        swipeGesture.delegate = self as UIGestureRecognizerDelegate
        self.view.isUserInteractionEnabled = true
        
        self.view.addGestureRecognizer(swipeGesture)
        
        view.addGestureRecognizer(tap)
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-7404153809143887/4170024190")
        let request = GADRequest()
        interstitial.load(request)
        
        interstitial.delegate = self
    }
    //TODO: PICKER VIEW CODE
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(component == 0)
        {
        return grades[row]
        }
        else
        {
            return weights[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(component == 0)
        {
        return grades.count
        }
        else {
            return weights.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(component==0){
            selectedGrade = grades[row]
        }
        else{
        selectedWeight = weights[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        
        var string = ""
        
        if #available(iOS 13.0, *) {
            pickerLabel.textColor = .secondaryLabel
        } else {
            pickerLabel.textColor = UIColor.lightGray
            // Fallback on earlier versions
        }
        
        if(component==0){
            string = grades[row]
        }
        else{
            string = weights[row]
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let title = NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font:
            UIFont(name: "Helvetica-Bold", size: 21.0)!, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        pickerLabel.attributedText = title
        
        
        return pickerLabel
    }
    
    //TODO: CREATE CLASS PRESSED
    @IBAction func createClassPressed(_ sender: Any) {
        if(userIsEditing){
            ProgressHUD.showSuccess("Edited Class")
            try! realm.write {
                let percent2 = vc.getPercent()
                print(PercentHandler().getLetterGrade(percent: percent2))
                print(vc.getWeight())
                classArray[editingIndex].useCalculatedGrade = false
                classArray[editingIndex].grade = selectedGrade
                classArray[editingIndex].credits = credits
                classArray[editingIndex].weight = selectedWeight
                classArray[editingIndex].name = classTextFieldContent.text!
                classArray[editingIndex].exempt = editSwitch.isOn
                classArray[editingIndex].isPercent = isPercent
                if isPercent{
                classArray[editingIndex].isPercent = true
                let percent = vc.getPercent()
                classArray[editingIndex].percent = percent
                print(percent)
                classArray[editingIndex].grade = PercentHandler().getLetterGrade(percent: percent)
                classArray[editingIndex].weight = vc.getWeight()
                }
            }
            print("class edited successfully")
        }
        else {
        ProgressHUD.showSuccess("Created Class")
        userIsEditing = false
            let newClass = Course()
        if(classTextFieldContent.text! != "")
        {
        newClass.name = classTextFieldContent.text!
        }
        else if (classTextFieldContent == nil)
        {
            newClass.name = "Untitled"
            print("found a caught nil")
        }
            if isPercent{
                newClass.isPercent = isPercent
                newClass.grade = PercentHandler().getLetterGrade(percent: vc.getPercent())
                newClass.weight = vc.getWeight()
                newClass.percent = vc.getPercent()
            }else{
                newClass.grade = selectedGrade
                newClass.weight = selectedWeight
            }
        newClass.credits = credits
        newClass.exempt = editSwitch.isOn
         
            try! realm.write {
                realm.add(newClass)
            }
            
        print("class save successfully")
        print("class added successfully, closing view")
        }
        dismissScreen()
    }
    
    @IBAction func tapOutButton(_ sender: Any) {
        userTappedOut = true
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = UIColor.clear
        }
        
        dismissScreen()
    }
    func dismissScreen(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        UIView.animate(withDuration: 0.2) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unDimScreen"), object: nil)
        }
        userIsEditing = false
        presentAd()
    }
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.dismiss(animated: true, completion: nil)
    }
    //TODO: CREDIT PICKER
    @IBAction func creditStepper(_ sender: UIStepper) {
        let number = Double(sender.value)
        credits = number
        creditLabel.text = String(number)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = classTextFieldContent.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 18
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
    func styleView(){
        
        backgroundView.layer.cornerRadius = 14
        backgroundView.clipsToBounds = true
        
        createButton.layer.cornerRadius = 10
        createButton.clipsToBounds = true
        
        
        
    }
    func initClass(){
        let save = UserDefaults.standard
        if classArray[editingIndex].isPercent && save.value(forKey: "Purchase") != nil{
        segmentedControl.selectedSegmentIndex = 1
        vc.view.frame = sectionView.bounds
        sectionView.addSubview(vc.view)
        isPercent = true
        }else{
        isPercent = false
        segmentedControl.selectedSegmentIndex = 0
        }
        isPercent = classArray[editingIndex].isPercent
        editSwitch.isOn = classArray[editingIndex].exempt
        selectedGrade = classArray[editingIndex].grade
        selectedWeight = classArray[editingIndex].weight
        name = classArray[editingIndex].name
        credits = classArray[editingIndex].credits
        
        classTextFieldContent.text = classArray[editingIndex].name
        creditLabel.text = String(classArray[editingIndex].credits)
        creditStepper.value = classArray[editingIndex].credits
        
        gradePicker.selectRow(grades.firstIndex(of:classArray[editingIndex].grade) ?? 0, inComponent: 0, animated: true)
        gradePicker.selectRow(weights.firstIndex(of:classArray[editingIndex].weight) ?? 0, inComponent: 1, animated: true)
        
            editLabel.text = "Edit Class"
            createButton.setTitle("Finish Editing",for: .normal)
        
    }
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer){
        
        let touchPoint = gesture.location(in: self.view.window)
        
        if(gesture.state == .began){
            print("began")
            
            
            print(self.view.frame.origin.y)
            print(self.view.bounds.maxY)
            print(initialTouchPoint)
            initialTouchPoint = touchPoint
            
        }
        else if(gesture.state == .changed){
                if touchPoint.y - initialTouchPoint.y > 0 {
                    print("changed")
                    print(initialY)
                    print(initialTouchPoint.y)
                    self.view.frame = CGRect(x: 0, y: (touchPoint.y - initialTouchPoint.y), width: self.view.frame.size.width, height: self.view.frame.size.height)
                    
            }
            
            
        }
        else if(gesture.state == .ended){
                if touchPoint.y - initialTouchPoint.y < 250{
                    print("ended2")
                    UIView.animate(withDuration: 0.3, animations: {
                        self.view.frame = CGRect(x: 0, y: 0
                            , width: self.view.frame.size.width, height: self.view.frame.size.height)
                        
                    })
                    print("end")
            }
        
         else {
                    print("ended1")
                   userTappedOut = true
                   dismissScreen()
                }
        }
        
        
        
    
    /*x
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    }

    @IBAction func switchAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            print("notifications")
            vc.view.removeFromSuperview()
            isPercent = false
            break
        case 1:
            let save = UserDefaults.standard
            if save.value(forKey: "Purchase") == nil{
                segmentedControl.selectedSegmentIndex = 0
                isPercent = false
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "premiumVIewController") as! premiumViewController
                self.present(vc, animated: true, completion: nil)
            }else{
                print("Calender view")
                vc.view.frame = sectionView.bounds
                sectionView.addSubview(vc.view)
                isPercent = true
            }
            break
        default:
            break
        }
        
        
    }
    
    
    
    
}

extension createClassViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


