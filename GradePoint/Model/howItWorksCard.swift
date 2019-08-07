//
//  howItWorksCard.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 8/3/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//

import UIKit

class howItWorksCard{
    var backgroundImage = UIImage()
    
    var backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5).cgColor
    var text = ""
    
    func initCard(i : UIImage, c : CGColor, t : String){
        backgroundImage = i
        backgroundColor = c
        text = t
    }
}
