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
    @IBOutlet weak var navItem: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightButtonItem = UIBarButtonItem.init(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(exitPressed(_:))
        )
        rightButtonItem.tintColor = #colorLiteral(red: 1, green: 0.662745098, blue: 0.07843137255, alpha: 1)
        
        self.navItem.title = "About"
        self.navItem.rightBarButtonItem = rightButtonItem
        
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
        body.append("Obtuse, rubber goose, green moose, guava juice. Giant snake, birthday cake, large fries, chocolate shake! Obtuse, rubber goose, green moose, guava juice. Giant snake, birthday cake, large fries, chocolate shake! Obtuse, rubber goose, green moose, guava juice. Giant snake, birthday cake, large fries, chocolate shake! Obtuse, rubber goose, green moose, guava juice. Giant snake, birthday cake, large fries, chocolate shake!Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.\n")
        
        title.append("\nCredits\n")
        body.append("test test test test test Obtuse, rubber goose, green moose, guava juice. Giant snake, birthday cake, large fries, chocolate shake! Obtuse, rubber goose, green moose, guava juice. Giant snake, birthday cake, large fries, chocolate shake! Obtuse, rubber goose, green moose, guava juice. Giant snake, birthday cake, large fries, chocolate shake! Obtuse, rubber goose, green moose, guava juice. Giant snake, birthday cake, large fries, chocolate shake! Obtuse, rubber goose, green moose, guava juice. Giant snake, birthday cake, large fries, chocolate shake!Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.\n")
        
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

