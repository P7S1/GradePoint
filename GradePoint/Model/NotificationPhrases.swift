//
//  NotificationPhrases.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 8/15/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//

import Foundation

class NotificationPhrases{
    
    let num = Int.random(in: 0...10)
    
    
    func getPhrase() -> String{
    switch num{
    case 0:
        return "Don't Forget!"
    case 1:
        return "Heres a friendly reminder!"
    case 2:
       return "Oh I almost forgot to tell you"
    case 3:
        return "Important"
    case 4:
        return "Ring Ring Ring"
    case 5:
        return "Reminder"
    case 6:
        return "It's about that time!"
    case 7:
        return "Just so you know"
    case 8:
        return "Important"
    case 9:
        return "Anyone There?"
    case 10:
        return "It's game time"
    default:
        return "Don't Forget!"
        }
    
    
    }
}
