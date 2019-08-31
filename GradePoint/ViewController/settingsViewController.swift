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
        
        self.title = "Settings"
        
        NotificationCenter.default.addObserver(self, selector: #selector(unDimScreen), name:NSNotification.Name(rawValue: "unDimScreen"), object: nil)
        
        settingOutlet.delegate = self
        settingOutlet.dataSource = self
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        settingOutlet.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row{
            case 0:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "aboutView") as? aboutViewController
                self.navigationController?.pushViewController(vc!, animated: true)
                print("About")
            case 1:
                print("Delete Data")
                deleteData()
            case 2:
                let vc = (self.storyboard?.instantiateViewController(withIdentifier: "premiumVIewController") as! premiumViewController)
                self.present(vc, animated: true, completion: nil)
                print("Remove ads")
            default:
                print("General section settings failure")
            }
        case 1:
            switch indexPath.row{
            case 0:
                print("Report Bug")
                self.performSegue(withIdentifier: "goToSupport", sender: self)

            case 1:
                print("Contact")
                let alert = UIAlertController(title: "Contact", message: "gradepointapp@gmail.com", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                
                alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (action: UIAlertAction!) in
                    UIPasteboard.general.string = "gradepointapp@gmail.com"
                }))
                
                self.present(alert, animated: true)
            case 2:
                print("Write a Review")
            requestReviewManually()
            default:
                print("Support section settings failure")
            }
        case 2:
            switch indexPath.row{
            case 0:
                print("Privacy Policy")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "privacyPolicyView") as? privacyPolicyViewController
                self.navigationController?.pushViewController(vc!, animated: true)
            default:
                print("Legal section settings failure")
            }
        default:
            print("Settings select Failure")
        }
    }
    @objc func unDimScreen(){
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1
            self.navigationController?.view.alpha = 1
        }
    }
    
    func deleteData(){
        let refreshAlert = UIAlertController(title: "Are you sure you want to delete all data?", message: "All data will be lost, and there is no way to recover it.", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
            completedReminderes.removeAll()
            reminders.removeAll()
            classArray.removeAll()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
        func requestReviewManually() {
        // Note: Replace the XXXXXXXXXX below with the App Store ID for your app
        //       You can find the App Store ID in your app's product URL
        guard let writeReviewURL = URL(string: "https://itunes.apple.com/app/id1477275391?action=write-review")
            else { fatalError("Expected a valid URL") }
        UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
    }
}
