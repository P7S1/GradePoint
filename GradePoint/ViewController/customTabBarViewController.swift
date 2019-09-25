//
//  customTabBarViewController.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 8/7/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import GoogleMobileAds
let transparentView = UIView()
class customTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var homeViewController: createClassViewController!
    var secondViewController: notificationsViewController!
    var actionViewController: createClassViewController!
    var thirdViewController: howItWorksViewController!
    var fourthViewController: settingViewController!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    
        
        self.delegate = self
        
        
        
        
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "addClassView") as! addClassViewController
        let item = UITabBarItem()
        item.title = "Calculate"
        item.image = UIImage(named: "icons8-calculator-100")
        homeViewController.tabBarItem = item
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "notificationsView") as! notificationsViewController
        let item2 = UITabBarItem()
        item2.title = "Calendar"
        item2.image = UIImage(named: "icons8-calendar-100")
        secondViewController.tabBarItem = item2
        
        let actionViewController = self.storyboard?.instantiateViewController(withIdentifier: "createView") as! createClassViewController?
        let item3 = UITabBarItem()
        item3.image = UIImage(named: "icons8-plus-97")
        actionViewController?.tabBarItem = item3
        
        let thirdViewController = self.storyboard?.instantiateViewController(withIdentifier: "howItWorksView") as! howItWorksViewController?
        let item4 = UITabBarItem()
        item4.title = "How It Works"
        item4.image = UIImage(named: "icons8-artificial-intelligence-100")
        thirdViewController?.tabBarItem = item4
        
        let fourthViewController = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! settingViewController?
        
        let item5 = UITabBarItem()
        item5.title = "Settings"
        
        let navigationController = UINavigationController(rootViewController: fourthViewController!)
        
        item5.image = UIImage(named: "icons8-settings-144")
        fourthViewController?.tabBarItem = item5
        
        viewControllers = [homeViewController, secondViewController, actionViewController, thirdViewController, navigationController] as? [UIViewController]
        
        var color = UIColor()
        if #available(iOS 13.0, *) {
            color = .secondaryLabel
        } else {
            color = .darkGray
            // Fallback on earlier versions
        }
        
        
        UINavigationBar.appearance().titleTextAttributes = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
        ,NSAttributedString.Key.foregroundColor : color]
        
        UINavigationBar.appearance().isTranslucent = false
        

        
        //remove titles
        for tabBarItem in tabBar.items! {
            tabBarItem.title = ""
            tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
        // Do any additional setup after loading the view.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        
        if viewController.isKind(of: createClassViewController.self) {
            UIView.animate(withDuration: 0.2) {
                self.selectedViewController?.view.alpha = 0.5
            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "createView") as! createClassViewController
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true)
            return false
        }
        print("")
        return true
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
