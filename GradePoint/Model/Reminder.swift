//
//  Reminder.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 8/9/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//
import UIKit
import UserNotifications
class oldReminder : Codable{

    var name : String = "Untitled"
    
    var completed : Bool = false
    
    var willNotify : Bool = false
    
    var due = Date()
    
    var reminder = Date()
    
    var course = Course()
    
    let uuid = UUID().uuidString
}
class Reminder: oldReminder{
    
    var notes = ""
    
    func initReminder(reminderName : String, isCompleted: Bool, dueDate: NSDate, newCourse: Course, remindOn: NSDate){
        name = reminderName
        
        completed = isCompleted
        
        due = dueDate as Date
        
        course = newCourse
        reminder = remindOn as Date
    }
    
    func equals(remind : Reminder) -> Bool{
        return remind.uuid == uuid
    }
    
}
