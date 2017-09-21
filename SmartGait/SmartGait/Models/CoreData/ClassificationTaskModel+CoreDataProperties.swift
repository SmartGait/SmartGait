//
//  ClassificationTaskModel+CoreDataProperties.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 06/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//
//

import Foundation
import CoreData

extension ClassificationTaskModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ClassificationTaskModel> {
        return NSFetchRequest<ClassificationTaskModel>(entityName: "ClassificationTaskModel")
    }

    @NSManaged public var endDate: NSDate?
    @NSManaged public var id: Int64
    @NSManaged public var identifier: String?
    @NSManaged public var startDate: NSDate?

}
