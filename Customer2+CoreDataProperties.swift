//
//  Customer2+CoreDataProperties.swift
//  ProjectIMT
//
//  Created by facetoface on 25/01/2023.
//
//

import Foundation
import CoreData


extension Customer2 {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Customer2> {
        return NSFetchRequest<Customer2>(entityName: "Customer2")
    }

    @NSManaged public var first_name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var last_name: String?
    @NSManaged public var number_of_transformations: Int64
    @NSManaged public var transformation_list: NSSet?

    public var transformationArray: [Transformation2]{
        let set = transformation_list as? Set<Transformation2> ?? []
        return set.sorted{
            $0.name ?? "Untitled"  < $1.name ?? "Untitled"
        }
    }
        
    func fullName() -> String? {
        let fullname = first_name! + " " + last_name!
        return(fullname)
    }
}

// MARK: Generated accessors for transformation_list
extension Customer2 {

    @objc(addTransformation_listObject:)
    @NSManaged public func addToTransformation_list(_ value: Transformation2)

    @objc(removeTransformation_listObject:)
    @NSManaged public func removeFromTransformation_list(_ value: Transformation2)

    @objc(addTransformation_list:)
    @NSManaged public func addToTransformation_list(_ values: NSSet)

    @objc(removeTransformation_list:)
    @NSManaged public func removeFromTransformation_list(_ values: NSSet)

}

extension Customer2 : Identifiable {

}
