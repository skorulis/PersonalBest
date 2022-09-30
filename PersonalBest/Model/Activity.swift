//Created by Alexander Skorulis on 26/9/2022.

import CryptoKit
import Foundation

/// Describes an activity that can be performed
struct Activity: Codable, Identifiable {
    let id: String
    let category: String
    let name: String
    let measurements: [MeasurementEntry]
    
    /*init(name: String, measurements: [MeasurementEntry]) {
        self.name = name
        self.measurements = measurements
        self.id = UUID().uuidString
    }
    
    init(name: String, measureTypes: [MeasurementType]) {
        self.name = name
        self.measurements = measureTypes.map { .init(type: $0, isRecord: true, defaultUnit: $0.defaultUnit) }
        self.id = UUID().uuidString
    }*/
    
    init(systemName: String,
         category: SystemCategory = .other,
         singleMeasure: MeasurementType
    ) {
        self.name = systemName
        self.measurements = [.init(type: singleMeasure, isRecord: true, defaultUnit: singleMeasure.defaultUnit) ]
        self.category = category.rawValue
        self.id = Self.hash(name: systemName)
    }
    
    init(systemName: String,
         category: SystemCategory = .other,
         tracking: ActivityTrackingType
    ) {
        self.name = systemName
        self.measurements = tracking.measurements
        self.id = Self.hash(name: systemName)
        self.category = category.rawValue
    }
    
    var measurementTypes: [MeasurementType] {
        measurements.map { $0.type }
    }
    
    private static func hash(name: String) -> String {
        let data = name.data(using: .utf8)!
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    var breakdownType: BreakdownType {
        let set = Set(measurementTypes)
        if set.contains(.reps) && set.contains(.weight) {
            return .repsWeight
        }
        if set.contains(.reps) {
            return .reps
        }
        fatalError("No breakdown for this activity")
    }
    
    func unit(type: MeasurementType) -> UnitType {
        return measurements.first(where: {$0.type == type})?.defaultUnit ?? type.defaultUnit
    }
    
    var primaryMeasure: MeasurementType {
        return measurements.first(where: {$0.isRecord})!.type
    }
    
}

struct MeasurementEntry: Codable {
    let type: MeasurementType
    let lowerIsBetter: Bool
    let defaultUnit: UnitType
    let isRecord: Bool // Whether this field should be considered a record
    
    init(type: MeasurementType,
         isRecord: Bool,
         lowerIsBetter: Bool = false,
         defaultUnit: UnitType
    ) {
        self.type = type
        self.isRecord = isRecord
        self.lowerIsBetter = lowerIsBetter
        self.defaultUnit = defaultUnit
    }
}
