//
//  AdditionalPhoto2+CoreDataProperties.swift
//  ProjectIMT
//
//  Created by facetoface on 26/01/2023.
//
//

import Foundation
import CoreData


extension AdditionalPhoto2 {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AdditionalPhoto2> {
        return NSFetchRequest<AdditionalPhoto2>(entityName: "AdditionalPhoto2")
    }

    @NSManaged public var after_date: Date?
    @NSManaged public var after_picture: String?
    @NSManaged public var before_date: Date?
    @NSManaged public var before_picture: String?
    @NSManaged public var number: Int32
    @NSManaged public var transformation_id: UUID?
    @NSManaged public var transformation: Transformation2?

}

extension AdditionalPhoto2 : Identifiable {

}
