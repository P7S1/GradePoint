//
//  gradesCollectionViewCell.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 9/19/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//

import UIKit

class gradesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var progress: UILabel!
    
    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var topBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 14
    contentView.layer.borderWidth = 1.0
        
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 12
        self.layer.shadowOpacity = 0.7
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.contentView.layer.cornerRadius).cgPath
    }
    
}
