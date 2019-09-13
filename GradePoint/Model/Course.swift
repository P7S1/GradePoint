//
//  File.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 7/14/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import RealmSwift
class oldCourse : Object, Codable{
   @objc dynamic var name = "No name"
   @objc dynamic var grade = "A"
   @objc dynamic var predictedGrade = "A"
   @objc dynamic var percent = 92
    @objc dynamic var isPercent = false
   @objc dynamic var credits = 0.5
   @objc dynamic var weight = "Regular"
   @objc dynamic var value = 0.0
   @objc dynamic var exempt = false
    @objc dynamic var nameEdited = false
    @objc dynamic var gradeEdited = false
    @objc dynamic var creditsEdited = false
    @objc dynamic var weightEdited = false
    
    
    
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
class Course : oldCourse{
    var syllabusArray : List<SyllabusItem> = List<SyllabusItem>()
    @objc dynamic var useCalculatedGrade = false
    @objc dynamic var goalPercent : Int = -1
}


