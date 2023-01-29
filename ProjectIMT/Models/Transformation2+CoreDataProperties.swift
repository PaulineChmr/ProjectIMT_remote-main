//
//  Transformation2+CoreDataProperties.swift
//  ProjectIMT
//
//  Created by facetoface on 26/01/2023.
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
    @NSManaged public var photo_list: NSSet?

    public var photoArray: [AdditionalPhoto2]{
        let set = photo_list as? Set<AdditionalPhoto2> ?? []
        return set.sorted{
            $0.number  < $1.number
        }
    }
}

// MARK: Generated accessors for photo_list
extension Transformation2 {

    @objc(addPhoto_listObject:)
    @NSManaged public func addToPhoto_list(_ value: AdditionalPhoto2)

    @objc(removePhoto_listObject:)
    @NSManaged public func removeFromPhoto_list(_ value: AdditionalPhoto2)

    @objc(addPhoto_list:)
    @NSManaged public func addToPhoto_list(_ values: NSSet)

    @objc(removePhoto_list:)
    @NSManaged public func removeFromPhoto_list(_ values: NSSet)

}

extension Transformation2 : Identifiable {

}
