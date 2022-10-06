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
    @NSManaged public var variants: Set<PBVariant>
    @NSManaged public var category: PBCategory
    
}

// MARK: - Computed values

extension PBActivity {
    
    var measurements: [MeasurementEntry] {
        return trackingType.measurements
    }
    
    var measurementTypes: [MeasurementType] {
        trackingType.measurements.map { $0.type }
    }
    
    var orderedVariations: [PBVariant] {
        return variants.sorted { v1, v2 in
            return v1.name < v2.name
        }
    }
    
    var orderedRecords: [PBRecordEntry] {
        let query = PBRecordEntry.fetch()
        query.sortDescriptors = [.init(key: "date", ascending: true)]
        query.predicate = NSPredicate(format: "activity == %@", self)
        return try! self.managedObjectContext!.fetch(query)
    }
    
}
