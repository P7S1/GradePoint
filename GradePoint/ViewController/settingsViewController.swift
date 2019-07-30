//
//  settingsViewController.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 7/23/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import StoreKit
class settingViewController : UITableViewController{
    
    @IBOutlet var settingOutlet: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
                navigationController?.navigationBar.barStyle = .black
        let addButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapButton))
        addButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationItem.leftBarButtonItem = addButton
        settingOutlet.delegate = self
        settingOutlet.dataSource = self
    }
  /*  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell
    }*/
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0
        {
            if indexPath.row == 0{
                howItWorks()
            }
            else if indexPath.row == 1{
                weights()
            }
            else{
                loveTheApp()
            }
        }else{
            if indexPath.row == 0{
                reportBugs()
            }
            else if indexPath.row == 1{
                aboutUs()
            }
            else{
                privacy()
            }
        }
            settingOutlet.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func tapButton() {
        // remove @objc for Swift 3
        self.dismiss(animated: true, completion: nil)
    }
    //Section 1
    func howItWorks(){
        print("How it works opened")
        settingsIndex = 1
        performSegue(withIdentifier: "goToImageView", sender: self)
    }
    func weights(){
        print("weights opened")
        settingsIndex = 2
        performSegue(withIdentifier: "goToImageView", sender: self)
    }
    func loveTheApp(){
        print("love the App opened")
        SKStoreReviewController.requestReview()
    }
    //Section 2
    func reportBugs(){
        print("report bugs opened")
    }
    func aboutUs(){
        print("about us opened")
        settingsIndex = 0
        performSegue(withIdentifier: "goToImageView", sender: self)
    }
    func privacy(){
        print("Privacy opened")
    }
}
