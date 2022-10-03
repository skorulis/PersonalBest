//Created by Alexander Skorulis on 3/10/2022.

import Foundation
import CoreData

@objc(PBRecordEntry)
public class PBRecordEntry: NSManagedObject, Identifiable {
 
    @nonobjc class func fetch() -> NSFetchRequest<PBRecordEntry> {
        return NSFetchRequest<PBRecordEntry>(entityName: "PBRecordEntry")
    }
    
    @NSManaged public var date: Date
    @NSManaged public var entryValuesData: Data
    @NSManaged public var activity: PBActivity
    
    static func new(activity: PBActivity, date: Date = Date(), values: [MeasurementType: Decimal]) -> PBRecordEntry {
        let record = PBRecordEntry(context: activity.managedObjectContext!)
        record.activity = activity
        record.date = date
        record.entryValues = values
        return record
    }
    
    var entryValues: [MeasurementType: Decimal] {
        get {
            try! JSONDecoder().decode([MeasurementType: Decimal].self, from: entryValuesData)
        }
        set {
            entryValuesData = try! JSONEncoder().encode(newValue)
        }
    }
    
    func set(type: MeasurementType, value: Decimal) {
        var dict = entryValues
        dict[type] = value
        entryValues = dict
    }
    
    func value(type: MeasurementType) -> Decimal? {
        return entryValues[type]
    }
    
    var dateString: String {
        return DateFormatter.mediumDate.string(from: date)
    }
    
    
}
