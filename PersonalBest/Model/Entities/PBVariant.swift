//Created by Alexander Skorulis on 6/10/2022.

import CoreData
import Foundation

@objc(PBVariant)
public class PBVariant: NSManagedObject, Identifiable {
 
    @nonobjc class func fetch() -> NSFetchRequest<PBVariant> {
        return NSFetchRequest<PBVariant>(entityName: "PBVariant")
    }
    
    @NSManaged public var name: String
    @NSManaged public var activity: PBActivity
    
    static let none: String = "None"
    
}

// MARK: - Logic

extension PBVariant {
    
    static func find(context: NSManagedObjectContext, name: String?) -> PBVariant? {
        guard let name else { return nil }
        if name == PBVariant.none {
            return nil
        }
        let query = PBVariant.fetch()
        query.predicate = NSPredicate(format: "name == %@", name)
        return try! context.fetch(query).first
    }
    
}
