//Created by Alexander Skorulis on 3/10/2022.

import Foundation
import CoreData

@objc(PBRecordEntry)
public class PBRecordEntry: NSManagedObject, Identifiable, PRecordEntry {
 
    @nonobjc class func fetch() -> NSFetchRequest<PBRecordEntry> {
        return NSFetchRequest<PBRecordEntry>(entityName: "PBRecordEntry")
    }
    
    @NSManaged public var date: Date
    @NSManaged public var entryValuesData: Data
    @NSManaged public var autoTypeString: String?
    
    @NSManaged public var activity: PBActivity
    @NSManaged public var variant: PBVariant?
    @NSManaged public var workout: PBWorkout?
    
    static func new(activity: PBActivity,
                    date: Date = Date(),
                    variant: PBVariant? = nil,
                    values: [MeasurementType: Double],
                    autoType: AutoRecordType? = nil
    ) -> PBRecordEntry {
        let record = PBRecordEntry(context: activity.managedObjectContext!)
        record.activity = activity
        record.date = date
        record.variant = variant
        record.entryValues = values
        record.autoType = autoType
        return record
    }
    
    var entryValues: [MeasurementType: Double] {
        get {
            try! JSONDecoder().decode([MeasurementType: Double].self, from: entryValuesData)
        }
        set {
            entryValuesData = try! JSONEncoder().encode(newValue)
        }
    }
    
    var autoType: AutoRecordType? {
        get {
            guard let string = autoTypeString else { return nil }
            return AutoRecordType(rawValue: string) ?? nil
        }
        set {
            self.autoTypeString = newValue?.rawValue
        }
        
    }
    
    var variantName: String? {
        return variant?.name
    }
    
    func set(type: MeasurementType, value: Double) {
        var dict = entryValues
        dict[type] = value
        entryValues = dict
    }
    
    func value(type: MeasurementType) -> Double? {
        return entryValues[type]
    }
    
    func convertedValue(type: MeasurementType) -> Double? {
        return self.convertedValue(type: type, toUnit: activity.currentUnit(type))
    }
    
    func topValueKey(type: MeasurementType) -> TopValueKey {
        return TopValueKey(measurement: type, autoType: autoType, variant: variantName)
    }
    
    var dateString: String {
        return DateFormatter.mediumDate.string(from: date)
    }
    
}

extension PBRecordEntry: Comparable {
    public static func < (lhs: PBRecordEntry, rhs: PBRecordEntry) -> Bool {
        // TODO: Handle backwards types
        assert(lhs.activity == rhs.activity, "Records must be from the same activity")
        switch lhs.activity.trackingType {
        case .weightlifting:
            return weightsCompare(lhs: lhs, rhs: rhs)
        case .time:
            return singleValueCompare(type: .time, lhs: lhs, rhs: rhs)
        case .reps:
            return singleValueCompare(type: .reps, lhs: lhs, rhs: rhs)
        case .cardio:
            return false // TODO: Cardio
        }
    }
    
    private static func weightsCompare(lhs: PBRecordEntry, rhs: PBRecordEntry) -> Bool {
        let w1 = lhs.value(type: .weight)!
        let w2 = rhs.value(type: .weight)!
        
        if w1 != w2 {
            return w1 < w2
        }
        
        let r1 = lhs.value(type: .reps)
        let r2 = rhs.value(type: .reps)
        
        if let r1, let r2, r1 != r2 {
            return r1 < r2
        }
        return lhs.date < rhs.date
    }
    
    private static func singleValueCompare(type: MeasurementType, lhs: PBRecordEntry, rhs: PBRecordEntry) -> Bool {
        let v1 = lhs.value(type: type)!
        let v2 = rhs.value(type: type)!
        
        if v1 != v2 {
            return v1 < v2
        }
        return lhs.date < rhs.date
    }
    
}
