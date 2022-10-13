//Created by Alexander Skorulis on 7/10/2022.

import Foundation

protocol PRecordEntry {
    var date: Date { get }
    var variantName: String? { get }
    var entryValues: [MeasurementType: Double] { get }
    
}

extension PRecordEntry {
    
    func convertedValue(type: MeasurementType, toUnit: UnitType) -> Double? {
        guard let base = entryValues[type] else { return nil }
        if type.defaultUnit == toUnit {
            return base
        }
        return MeasurementType.convert(value: base, from: type.defaultUnit, to: toUnit)
    }
    
}

/// record entry not linked to core data
struct RecordEntry: PRecordEntry {
    
    let date: Date
    let variantName: String?
    let entryValues: [MeasurementType: Double]
    
}
