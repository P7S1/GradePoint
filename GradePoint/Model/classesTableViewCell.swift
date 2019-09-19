//
//  classesTableViewCell.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 7/15/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//

import UIKit

class classesTableViewCell: UITableViewCell {
    @IBOutlet weak var class_Name: UILabel!
    @IBOutlet weak var class_Weight: UILabel!
    @IBOutlet weak var class_Grade: UILabel!
    @IBOutlet weak var class_credit: UILabel!
    @IBOutlet weak var class_Background: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        class_Background.layer.cornerRadius = 10;
        class_Background.layer.masksToBounds = true;
        
        class_Background.layer.shadowColor = UIColor.gray.cgColor
        class_Background.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        class_Background.layer.shadowRadius = 12.0
        class_Background.layer.shadowOpacity = 0.7
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
