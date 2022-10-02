//Created by Alexander Skorulis on 3/10/2022.

import Foundation
import CoreData

@objc(PBActivityCategory)
public class PBActivityCategory: NSManagedObject, Identifiable {
 
    @nonobjc class func fetch() -> NSFetchRequest<PBActivityCategory> {
        return NSFetchRequest<PBActivityCategory>(entityName: "PBActivityCategory")
    }
    
    @NSManaged public var name: String
    
    @NSManaged public var activities: Set<PBActivity>
    
}
