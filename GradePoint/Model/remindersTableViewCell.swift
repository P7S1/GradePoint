//
//  remindersTableViewCell.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 8/9/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//

import UIKit

class remindersTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var dueDate: UILabel!
    
    
    @IBOutlet weak var className: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var completedText: UILabel!
    
    @IBOutlet weak var cellBackground: UIView!
    
    @IBOutlet weak var notificationImage: UIImageView!
    
    @IBOutlet weak var hasAttachment: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellBackground.layer.masksToBounds = true
        cellBackground.layer.cornerRadius = 10
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
