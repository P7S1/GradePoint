//
//  Course+CoreDataProperties.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 7/21/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//
//

import Foundation
import CoreData


extension Course {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Course> {
        return NSFetchRequest<Course>(entityName: "Course")
    }

    @NSManaged public var name: String?
    @NSManaged public var credits: Double
    @NSManaged public var weight: String?
    @NSManaged public var grade: String?

}
