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
    
    var units: [MeasurementType: KnownUnit] {
        get {
            guard let data = unitsData else { return [:] }
            return try! JSONDecoder().decode([MeasurementType: KnownUnit].self, from: data)
        }
        set {
            if newValue.isEmpty {
                unitsData = nil
            } else {
                unitsData = try! JSONEncoder().encode(newValue)
            }
        }
    }
    
    static func new(context: NSManagedObjectContext, name: String, tracking: ActivityTrackingType) -> PBActivity {
        let activity = PBActivity(context: context)
        activity.name = name
        activity.trackingType = tracking
        return activity
    }
    
    @NSManaged public var name: String
    @NSManaged public var trackingTypeString: String
    @NSManaged private var unitsData: Data?
    
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
    
    var primaryMeasure: MeasurementType {
        trackingType.primaryMeasure
    }
    
    var orderedRecords: [PBRecordEntry] {
        let query = PBRecordEntry.fetch()
        query.sortDescriptors = [.init(key: "date", ascending: true)]
        query.predicate = NSPredicate(format: "activity == %@", self)
        return try! self.managedObjectContext!.fetch(query)
    }
    
    var editableUnits: [MeasurementType] {
        return measurementTypes.filter { $0.unitOptions.count > 1}
    }
    
    func currentUnit(_ measurement: MeasurementType) -> KnownUnit {
        return units[measurement] ?? trackingType.unit(for: measurement)
    }
    
    var unitSelectionID: String {
        return measurementTypes.map { self.currentUnit($0).rawValue }.joined(separator: "-")
    }
    
    var variantsID: String {
        return variants.map { $0.name }.joined(separator: "-")
    }
    
}
