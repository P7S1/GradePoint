//
//  bigCalendarViewController.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 8/12/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import FSCalendar
import DJSemiModalViewController
class bigCalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDelegate,FSCalendarDataSource{

  
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var background: UIView!
    
    @IBOutlet weak var calendarOutlet: UITableView!
    
    var calendarReminders : [Reminder] = [Reminder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        calendarOutlet.dataSource = self
        calendarOutlet.delegate = self
        
        calendar.delegate = self
        calendar.dataSource = self
        
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.bold)
        calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        
        self.background.layer.cornerRadius = 15
        self.background.clipsToBounds = true
        
        reloadDate(date: Date())
        // Do any additional setup after loading the view.
    }
    //TODO: FSCalendar
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("selected date")
        
        reloadDate(date: date)
    }
    
    func reloadDate(date: Date){
        calendarReminders.removeAll()
        
        if reminders.count > 0{
        for i in 0...reminders.count-1{
            
            if isSameDay(date1: reminders[i].due, date2: date){
                calendarReminders.append(reminders[i])
                print("found matching date in calender for not completed")
            }
        }
        }
        
        if completedReminderes.count > 0{
        for i in 0...completedReminderes.count-1{
            if isSameDay(date1: completedReminderes[i].due, date2: date){
                calendarReminders.append(completedReminderes[i])
                print("found matching date in calender for not completed")
            }
        }
    }
        calendarOutlet.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let date = calendar.selectedDate{
            
            reloadDate(date: date)
        }else{
            reloadDate(date: Date())
        }
    }
    
    //TODO: Table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendarReminders.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath) as! remindersTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let cellReminder = calendarReminders[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd")
        let stringDate = dateFormatter.string(from: cellReminder.due as Date)
        
        dateFormatter.dateFormat = "hh:mm a"
        let stringTime = dateFormatter.string(from: cellReminder.reminder as Date)
        
        cell.name.text = cellReminder.name
        cell.dueDate.text = stringDate
        
        if cellReminder.willNotify{
            cell.time.text = stringTime
        }
        if cellReminder.completed{
            cell.completedText.text = "Completed"
            cell.completedText.textColor = #colorLiteral(red: 0.2352941176, green: 1, blue: 0.3333333333, alpha: 1)
        }
        else{
            cell.completedText.text = "Not Completed"
            cell.completedText.textColor = #colorLiteral(red: 1, green: 0.3098039216, blue: 0.2666666667, alpha: 1)
        }
        cell.className.text = cellReminder.course.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                tableView.deselectRow(at: indexPath, animated: true)
        
        var indexpath = IndexPath()
        if reminders.count > 0{
        for i in 0...reminders.count-1{
            if reminders[i].equals(remind: calendarReminders[indexPath.row])
            {
                indexpath = IndexPath(row: i, section: 0)
                print("reminder match \(indexpath))")
            }
        }
        }
        if completedReminderes.count>0 {
        for i in 0...completedReminderes.count-1{
            if completedReminderes[i].equals(remind: calendarReminders[indexPath.row])
            {
                indexpath = IndexPath(row: i, section: 1)
                
                print("completed reminder match \(indexpath)")
            }
        }
        }
        
        editingIndexPath = indexpath
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "presentNotification"), object: nil)
    }
    
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let cal = NSCalendar.current
        return  cal.isDate(date1, inSameDayAs: date2)
    }
    
    func getIndexPath(reminder : Reminder) -> IndexPath{
        var indexpath = IndexPath()
        
        for i in 0...reminders.count-1{
            if reminders[i].name == reminder.name{
                indexpath.section = 0
                indexpath.row = i
                return indexpath
            }
        }
        for i in 0...completedReminderes.count-1{
            if completedReminderes[i].name == reminder.name{
                indexpath.section = 1
                indexpath.row = i
                return indexpath
            }
        }
        return indexpath
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
