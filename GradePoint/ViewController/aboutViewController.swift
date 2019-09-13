//
//  aboutViewController.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 8/5/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//

import UIKit

class aboutViewController: UIViewController {

    @IBOutlet weak var textOutlet: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
            self.navigationItem.title = "About"
        
        let titleAttributes = [NSAttributedString.Key.font:
            UIFont(name: "Helvetica-Bold", size: 34.0)!,
                          NSAttributedString.Key.foregroundColor: UIColor.black] as [NSAttributedString.Key: Any]
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 10
        let bodyAttributes = [NSAttributedString.Key.font:
            UIFont(name: "Helvetica-Bold", size: 17.0)!, NSAttributedString.Key.paragraphStyle: paragraphStyle,
                               NSAttributedString.Key.foregroundColor: UIColor.lightGray] as [NSAttributedString.Key: Any]
        
        var body : [String] = [String]()
        var title : [String] = [String]()
        
        title.append("\nAbout\n")
        body.append("GradePoint is an ad supported/freemium iOS app created by me, a 17 year old iOS developer. I created this app to explore the world of computer science and hopefully inspire others to do the same. I also wanted to solve a problem many students faced, which was calculating their GPA and remembering when assignments were due. GPA's are typically only released at the end of the semester/grading period and old fashioned planners aren't always with you and don't remind you about it's them in real time. With this app, the end of the semester is a little less stressful since you know what to expect and with homework reminders, a student no longer has to utter the dreaded phrase: \("There Was Homework Due Today??!!") \n")
        
        title.append("\nCredits\n")
        body.append("Graduation cap icon made by “Freepik” from www.flaticon.com \n \n Share icon created by  SmashIcons from www.flaticon.com \n \n Menu icon created by Eleonor Wang from www.flaticon.com. \n")
        
        let output = NSMutableAttributedString()
        
        for i in 0...title.count - 1{
            print("body size: \(body.count)")
            print("title size: \(title.count)")
            print(" \(i)")
            
            let body = NSAttributedString(string: body[i], attributes: bodyAttributes)
            
            let title = NSAttributedString(string: title[i], attributes: titleAttributes)
            
            output.append(title)
            output.append(body)
        }
        
        textOutlet.attributedText = output
        
        
        

        // Do any additional setup after loading the view.
    }
    @objc func exitPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    


}

