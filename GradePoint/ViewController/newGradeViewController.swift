//
//  newGradeViewController.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 9/19/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import TGLStackedViewController
import RealmSwift
class newGradeViewController:TGLStackedViewController, UIGestureRecognizerDelegate {
    
    var localIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector( loadlist), name:NSNotification.Name(rawValue: "addSyllabusItem"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector( miniLoad), name:NSNotification.Name(rawValue: "addMiniItem"), object: nil)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.dragInteractionEnabled = false
        // Do any additional setup after loading the view.
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if syllabusArray.count == 0{
            self.collectionView.setEmptyMessage("No syllabus items, press the plus button at the top right to add some")
        }else{
            self.collectionView.restore()
        }
        return syllabusArray.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cell for row at \(indexPath.row)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gradeCalcCell", for: indexPath) as! gradesCollectionViewCell
        try! realm.write {
            syllabusArray[indexPath.row].tag = indexPath.row
        }
            let syllabus = syllabusArray[indexPath.row]
            
        cell.editButton.tag = syllabus.tag
        cell.addButton.tag = syllabus.tag
             cell.name.text = syllabus.name
             cell.progress.text = "\(String(format: "%.0f", syllabus.current))%/\(String(format: "%.0f", syllabus.possible))%"
             
            let childVC = self.storyboard?.instantiateViewController(withIdentifier: "syllabusItemsViewController") as! syllabusItemsViewController
             
             childVC.localIndex = indexPath.row
             childVC.view.frame = cell.view.bounds
             childVC.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = true
             cell.view.addSubview(childVC.view)
            self.addChild(childVC)
            childVC.didMove(toParent: self)

        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, didSelectItemAt: indexPath)
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        super.collectionView(collectionView, canMoveItemAt: indexPath)
        return false
    }
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        try! realm.write {
            let temp = syllabusArray[sourceIndexPath.row]
            syllabusArray.remove(at: sourceIndexPath.row)
            syllabusArray.insert(temp, at: destinationIndexPath.row)
        }

    }
    
    @objc func miniLoad(){
        loadlist()
    }
    @objc func loadlist(){
        collectionView.reloadData()
    }
    @IBAction func editButtonPressed(_ sender: UIButton) {
        let save = UserDefaults.standard
        if save.value(forKey: "Purchase") == nil{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "premiumVIewController") as! premiumViewController
            self.present(vc, animated: true, completion: nil)
        }else{
        print("edit pressed at tag \(sender.tag)")
        for i in 0...syllabusArray.count-1{
            if syllabusArray[i].tag == sender.tag{
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "addSyllabusItemViewController") as? addSyllabusItemViewController
        editingIndex = i
        userIsEditing = true
        self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
        }
        
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        gestureRecognizer.view == self.view
    }
    @IBAction func addPressed(_ sender: UIButton) {
        let save = UserDefaults.standard
        if save.value(forKey: "Purchase") == nil{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "premiumVIewController") as! premiumViewController
            self.present(vc, animated: true, completion: nil)
        }else{
        print("add pressed at tag \(sender.tag)")
        for i in 0...syllabusArray.count-1{
            if syllabusArray[i].tag == sender.tag{
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "createSyllabusItemViewController") as? createSyllabusItemViewController
        vc?.localIndex = i
        print("vc is ineed \(i)")
        self.navigationController?.pushViewController(vc!, animated: true)
        }
            }
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

extension UICollectionView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        if #available(iOS 13.0, *) {
            messageLabel.textColor = .secondaryLabel
        } else {
            messageLabel.textColor = .lightGray
            // Fallback on earlier versions
        }
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = .systemFont(ofSize: 17, weight: .medium)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

    func restore() {
        self.backgroundView = nil
    }
}
