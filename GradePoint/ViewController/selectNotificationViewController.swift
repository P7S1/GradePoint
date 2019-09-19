//
//  selectNotificationViewController.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 9/14/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class selectNotificationViewController: UIViewController {
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var due: UILabel!
    @IBOutlet weak var remind: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var attachmentButton: UIButton!
    var reminder = Reminder()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attachmentButton.clipsToBounds = true
        attachmentButton.layer.cornerRadius = 10
        
        if editingIndexPath.section == 0{
            reminder = reminders[editingIndexPath.row]
        }else{
            reminder = completedReminderes[editingIndexPath.row]
        }
        print("Reminder set safely")
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM dd, yyyy")
        var stringDate = dateFormatter.string(from: reminder.due as Date)
        stringDate = "Due \(stringDate)"
        var stringTime = ""
        if(reminder.willNotify)
        {
            dateFormatter.setLocalizedDateFormatFromTemplate("h:mm a MMMM dd")
            stringTime = dateFormatter.string(from: reminder.reminder as Date)
            stringTime = "Will remind on \(stringTime)"
            
        }else{
            stringTime = "No reminders"
        }
        
        name.text = reminder.name
        
        due.text = stringDate
        
        remind.text = stringTime
        
        textView.text = reminder.notes

        // Do any additional setup after loading the view.
    }
    @IBAction func viewAttachment(_ sender: Any) {
        if reminder.image != nil{
            if let img = UIImage(data: reminder.image!){
            presentImage(img: img)
            }else{
                print("error loading image")
                ProgressHUD.showError("No image found")
            }
        }else{
            print("error laoding data")
            ProgressHUD.showError("No image found")
        }
    }
    func presentImage(img : UIImage){
        print("Presenting Image Attachment")
        // 1. create SKPhoto Array from UIImage
        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImage(img)// add some UIImage
        images.append(photo)
        
        // 2. create PhotoBrowser Instance, and present from your viewController.
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        present(browser, animated: false, completion: {})
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
