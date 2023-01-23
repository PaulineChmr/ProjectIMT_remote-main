//
//  Transformation2+CoreDataProperties.swift
//  ProjectIMT
//
//  Created by facetoface on 23/01/2023.
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
    @NSManaged public var buccinateur_paralyse: Double
    @NSManaged public var buccinateur_sain: Double
    @NSManaged public var corrugator_paralyse: Double
    @NSManaged public var corrugator_sain: Double
    @NSManaged public var dao_paralyse: Double
    @NSManaged public var dao_sain: Double
    @NSManaged public var dli_paralyse: Double
    @NSManaged public var dli_sain: Double
    @NSManaged public var elevator_paralyse: Double
    @NSManaged public var elevator_sain: Double
    @NSManaged public var frontalis_paralyse: Double
    @NSManaged public var frontalis_sain: Double
    @NSManaged public var grandzygo_paralyse: Double
    @NSManaged public var grandzygo_sain: Double
    @NSManaged public var id: UUID?
    @NSManaged public var mentalis_paralyse: Double
    @NSManaged public var mentalis_sain: Double
    @NSManaged public var name: String?
    @NSManaged public var orbicularis_paralyse: Double
    @NSManaged public var orbicularis_sain: Double
    @NSManaged public var petitzygo_paralyse: Double
    @NSManaged public var petitzygo_sain: Double
    @NSManaged public var platysma_paralyse: Double
    @NSManaged public var platysma_sain: Double
    @NSManaged public var rlsan_paralyse: Double
    @NSManaged public var rlsan_sain: Double
    @NSManaged public var customer: Customer2?

}

extension Transformation2 : Identifiable {

}
