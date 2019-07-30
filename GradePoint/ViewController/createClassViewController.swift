//
//  createClassViewController.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 7/15/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//
import StoreKit
import UIKit
import CoreData
class createClassViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var gradePicker: UIPickerView!
    @IBOutlet weak var classTextFieldContent: UITextField!
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var creditStepper: UIStepper!
    @IBOutlet weak var editLabel: UILabel!
    var name = ""
    var credits = 0.5
    var selectedGrade = "A+"
    var selectedWeight = "Regular"
    let grades = ["A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "D-", "F"]
    let weights = ["Regular", "Honors", "AP", "IB SL", "IB HL"]
    let labelTexts = ["Grade", "Weight"]
    @IBOutlet weak var background: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(userIsEditing)
        {
        initClass()
        }
        classTextFieldContent.delegate = self
        styleView()
        // Do any additional setup after loading the view.
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
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var string = ""
        if(component==0){
            string = grades[row]
        }
        else{
            string = weights[row]
        }
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)])
    }
    //TODO: CREATE CLASS PRESSED
    @IBAction func createClassPressed(_ sender: Any) {
        if(userIsEditing){
         classArray[editingIndex].grade = selectedGrade
         classArray[editingIndex].credits = credits
         classArray[editingIndex].weight = selectedWeight
         classArray[editingIndex].name = classTextFieldContent.text!
            print("class edited successfully")
        }
        else {
        userIsEditing = false
            let newClass = Course()
        if(classTextFieldContent.text! != "")
        {
        newClass.name = classTextFieldContent.text!
        }
        else if (classTextFieldContent == nil)
        {
            newClass.name = "No Name"
            print("found a caught nil")
        }
        newClass.grade = selectedGrade
        newClass.credits = credits
        newClass.weight = selectedWeight
        classArray.append(newClass)
            
        print("class save successfully")
        print("class added successfully, closing view")
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        dismiss(animated: true, completion:nil)
    }
    
    @IBAction func tapOutButton(_ sender: Any) {
        userTappedOut = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        dismiss(animated: true, completion:nil)
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
        return count <= 16
    }
    func styleView(){
        createButton.layer.cornerRadius = 10
        createButton.clipsToBounds = true
        
        background.clipsToBounds = true
        background.layer.cornerRadius = 20
        background.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        
    }
    func initClass(){
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
    /*x
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension createClassViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
