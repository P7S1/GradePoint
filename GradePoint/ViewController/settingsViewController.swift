//
//  settingsViewController.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 7/23/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import StoreKit
var gestureEnabled = false;

var menuIndex = 0;
class settingViewController : UITableViewController{
    
    var menuArray : [menuItem] = [menuItem]()
    
    let loveTheApp = 0;
    let howItWorks = 1;
    let credits = 2;
    let donate = 3;
    let privacy = 4;
    
    @IBOutlet var settingOutlet: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gestureEnabled = true
        self.view.isUserInteractionEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(dismissView), name: NSNotification.Name("hello"), object: nil)
                navigationController?.navigationBar.barStyle = .black
        
        settingOutlet.delegate = self
        settingOutlet.dataSource = self
        
        initMenuArray()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSettingsCell(index: indexPath.row)
        settingOutlet.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! menuTableViewCell
        
        if menuArray.count>0{
        cell.displayText.text = menuArray[indexPath.row].name
        cell.displayImage.image = menuArray[indexPath.row].image
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
        cell.layer.transform = rotationTransform
        
        UIView.animate(withDuration: 0.4){
            cell.layer.transform = CATransform3DIdentity
        }
    }
    @objc func dismissView() {
        // remove @objc for Swift 3
        gestureEnabled = false
        self.dismiss(animated: true, completion: nil)
    }
    func initMenuArray(){
        let lovetheapp = menuItem()
        let howitworks = menuItem()
        let credits = menuItem()
        let donate = menuItem()
        let privacyp = menuItem()
        
        lovetheapp.name = "Love the app?"
        howitworks.name = "How it works"
        credits.name = "About"
        donate.name = "Donate"
        privacyp.name = "Privacy Policy"
        
        lovetheapp.image = UIImage(named: "love")!
        howitworks.image = UIImage(named: "howitworks")!
        credits.image = UIImage(named: "about")!
        donate.image = UIImage(named:"icons8-donate-100")!
        privacyp.image = UIImage(named: "privacy")!
        
        menuArray.append(lovetheapp)
        menuArray.append(howitworks)
        menuArray.append(credits)
        menuArray.append(donate)
        menuArray.append(privacyp)
       settingOutlet.beginUpdates()
       for i in 0...menuArray.count{
            let indexPath = IndexPath(row: i, section:0)
             settingOutlet.insertRows(at: [indexPath], with: .automatic)
        } 

        settingOutlet.endUpdates()
    }
    func dismissHome(){
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name:
                NSNotification.Name("presentHIW"), object: nil)
        }
    }
    func performSettingsCell(index : Int){
        switch index{
        case loveTheApp:
            print("love the app pressed")
            SKStoreReviewController.requestReview()
        case howItWorks:
            menuIndex = 0
            print("How it works pressed")
            dismissHome()
        case credits:
            menuIndex = 2
            print("credits pressed")
            dismissHome()
        case donate:
            print("donate pressed")
            let url = URL(string: "https://www.gofundme.com/gradepoint-expenses")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                //If you want handle the completion block than
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                    print("Open url : \(success)")
                })
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        case privacy:
            print("Privacy policy pressed")
            menuIndex = 1
            dismissHome()
        default:
            break
        }
    }
    
}
