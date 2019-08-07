//
//  menuTableViewCell.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 8/1/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//

import UIKit

class menuTableViewCell: UITableViewCell {

    @IBOutlet weak var displayImage: UIImageView!
    
    @IBOutlet weak var displayText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
