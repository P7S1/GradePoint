//
//  syllabusTableViewCell.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 9/8/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//

import UIKit

class syllabusTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var progress: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var needed: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
