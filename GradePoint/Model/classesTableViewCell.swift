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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
