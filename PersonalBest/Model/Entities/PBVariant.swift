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
    
    
}
