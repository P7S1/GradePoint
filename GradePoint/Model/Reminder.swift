//
//  Reminder.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 8/9/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//
import UIKit
import UserNotifications
import RealmSwift
class oldReminder : Object, Codable{

    @objc dynamic var name : String = "Untitled"
    
    @objc dynamic var completed : Bool = false
    
    @objc dynamic var willNotify : Bool = false
    
    @objc dynamic var due = Date()
    
    @objc dynamic var  reminder = Date()
    
    @objc dynamic var  course : Course?
    @objc dynamic var uuid = UUID().uuidString
}
class Reminder: oldReminder{
    
    @objc dynamic var notes = ""
    
   @objc dynamic var repeats = "never"
    
    @objc dynamic var  priority = 0
    
    @objc dynamic var image : Data?
    
    func initReminder(reminderName : String, isCompleted: Bool, dueDate: NSDate, newCourse: Course, remindOn: NSDate){
        name = reminderName
        
        completed = isCompleted
        
        due = dueDate as Date
        
        course = newCourse
        reminder = remindOn as Date
    }
    
    func match(remind : Reminder){
        name = remind.name
        
        completed = remind.completed
        
        due = remind.due
        
        willNotify = remind.willNotify
        
        course = remind.course
        
        reminder = remind.reminder
        
        notes = remind.notes
        
        repeats = remind.repeats
        
        priority = remind.priority
        
        image = remind.image
        
        uuid = remind.uuid
    }
    
    func equals(remind : Reminder) -> Bool{
        return remind.uuid == uuid
    }
    
}
