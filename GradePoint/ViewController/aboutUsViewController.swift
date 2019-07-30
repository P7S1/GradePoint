//
//  aboutUsViewController.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 7/23/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//

import UIKit
var settingsIndex = 0
class aboutUsViewController: UIViewController {
    @IBOutlet weak var textField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(settingsIndex == 0)
        {
            self.title = "About us"
        textField.text = "The app GradePoint is created by a 17 year old aspiring software engineer in Columbus, Ohio. I created this app to help with a problem that not just me, that many of my classmates face. The ability to calculate your GPA anytime you want is a helpful feature for many students. It helps them keep up with it and continue to better themselves in their acedemic journeys. I created this in hopes of exploring the world of computer programming while leaving a positive influence on the world."
        }
        else if(settingsIndex == 1){
            self.title = "How it Works"
                    textField.text = "Your GPA is calculated by Points divided by Credits. Your credits infomration is given, while the points is calculated by multiplying the value of class by the credits. The value is determined depending on the grade and weight of the course. See the weights section of settings explore more about the weights of the different classes "
        }
        else{
            self.title = "Weights"
            textField.text = ""
        }
        // Do any additional setup after loading the view.
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
