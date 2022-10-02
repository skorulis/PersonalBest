//Created by Alexander Skorulis on 3/10/2022.

import Foundation
import CoreData

@objc(PBActivity)
public class PBActivity: NSManagedObject, Identifiable {
 
    @nonobjc class func fetch() -> NSFetchRequest<PBActivity> {
        return NSFetchRequest<PBActivity>(entityName: "PBActivity")
    }
    
    var trackingType: ActivityTrackingType {
        get {
            return ActivityTrackingType(rawValue: trackingTypeString)!
        }
        set {
            trackingTypeString = newValue.rawValue
        }
        
    }
    
    @NSManaged public var name: String
    @NSManaged public var trackingTypeString: String
    
    @NSManaged public var records: Set<PBRecordEntry>
    
}
