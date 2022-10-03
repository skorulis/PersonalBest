//Created by Alexander Skorulis on 3/10/2022.

import Foundation
import CoreData

@objc(PBCategory)
public class PBCategory: NSManagedObject, Identifiable {
 
    @nonobjc class func fetch() -> NSFetchRequest<PBCategory> {
        return NSFetchRequest<PBCategory>(entityName: "PBCategory")
    }
    
    @NSManaged public var name: String
    
    @NSManaged public var activities: Set<PBActivity>
    
}
