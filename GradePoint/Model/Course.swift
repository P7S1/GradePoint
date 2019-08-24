//
//  File.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 7/14/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//

import UIKit
class Course : Codable{
   var name = "No name"
   var grade = "A"
   var credits = 0.5
   var weight = "Regular"
    var value = 0.0
    var exempt = false
    var nameEdited = false
    var gradeEdited = false
    var creditsEdited = false
    var weightEdited = false

    func getGradeColor() -> UIColor{
        switch grade{
        case "A+","A","A-","B+","B":
            return UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        case "B-", "C+", "C", "C-":
            return UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1)
        case "D+","D","D-","F":
            return UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
        default:
            break
        }
        return UIColor.black
    }
    
    

}


