//
//  Transformation2+CoreDataProperties.swift
//  ProjectIMT
//
//  Created by facetoface on 10/01/2023.
//
//

import Foundation
import CoreData


extension Transformation2 {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transformation2> {
        return NSFetchRequest<Transformation2>(entityName: "Transformation2")
    }

    @NSManaged public var after_date: Date?
    @NSManaged public var after_picture: String?
    @NSManaged public var before_date: Date?
    @NSManaged public var before_picture: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var customer: Customer2?

}

extension Transformation2 : Identifiable {

}
