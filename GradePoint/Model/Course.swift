//
//  File.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 7/14/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import CoreData
class Course : Codable{
   var name = "No name"
   var grade = "A"
   var credits = 0.5
   var weight = "Regular"
    var value = 0.0
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
    func getValue() -> Double{
    switch grade{
    case "A+":
    switch weight{
    case "Regular":
    return 4.3
    case "Honors", "IB SL":
    return  4.8375
    case "IB HL","AP":
    return 5.375
    default:
    break
    }
    case "A":
    switch weight{
    case "Regular":
    return 4.0
    case "Honors", "IB SL":
    return 4.5
    case "IB HL","AP":
    return 5.0
    default:
    break
    
    }
    case "A-":
    switch weight{
    case "Regular":
    return 3.7
    case "Honors", "IB SL":
    return 4.1625
    case "IB HL","AP":
    return 4.6250
    default:
    break
    
    }
    case "B+":
    switch weight{
    case "Regular":
    return 3.3
    case "Honors", "IB SL":
    return 3.715
    case "IB HL","AP":
    return 4.1250
    default:
    break
    
    }
    case "B":
    switch weight{
    case "Regular":
    return 3.0
    case "Honors", "IB SL":
    return 3.3750
    case "IB HL","AP":
    return 3.750
    default:
    break
    
    }
    case "B-":
    switch weight{
    case "Regular":
    return 2.7
    case "Honors", "IB SL":
    return 3.0375
    case "IB HL","AP":
    return 3.375
    default:
    break
    
    }
    case "C+":
    switch weight{
    case "Regular":
    return 2.3
    case "Honors", "IB SL":
    return 2.5875
    case "IB HL","AP":
    return 2.875
    default:
    break
    
    }
    case "C":
    switch weight{
    case "Regular":
    return 2
    case "Honors", "IB SL":
    return 2.25
    case "IB HL","AP":
    return 2.5
    default:
    break
    
    }
    case "C-":
    switch weight{
    case "Regular":
    return 1.7
    case "Honors", "IB SL":
    return 1.9125
    case "IB HL","AP":
    return 2.125
    default:
    break
    
    }
    case "D+":
    switch weight{
    case "Regular":
    return 1.3
    case "Honors", "IB SL":
    return 1.4625
    case "IB HL","AP":
    return 1.625
    default:
    break
    
    }
    case "D":
    switch weight{
    case "Regular":
    return 1
    case "Honors", "IB SL":
    return 1.125
    case "IB HL","AP":
    return 1.25
    default:
    break
    
    }
    case "D-":
    switch weight{
    case "Regular":
    return 0.7
    case "Honors", "IB SL":
    return 0.785
    case "IB HL","AP":
    return 0.8750
    default:
    break
    
    }
    case "F":
    return 0
    default:
    print("Grade declaration Failed")
    break
    }
    return 0
    }
}


