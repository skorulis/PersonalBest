//Created by Alexander Skorulis on 17/10/2022.

import Foundation

struct RecordKey: Equatable, Hashable, Identifiable {
    let autoType: AutoRecordType?
    let variant: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(autoType?.rawValue)
        hasher.combine(nonOptVariant)
    }
    
    var id: String {
        return "\(autoType?.rawValue ?? "")-\(nonOptVariant)"
    }
    
    private var nonOptVariant: String {
        return variant ?? PBVariant.none
    }
    
    static func == (lhs: RecordKey, rhs: RecordKey) -> Bool {
        return lhs.autoType == rhs.autoType && lhs.nonOptVariant == rhs.nonOptVariant
    }
    
    var suffix: String? {
        var result = ""
        if let variant {
            result += "(\(variant)) "
        }
        switch autoType {
        case .none:
            break
        case .volume:
            result += "volume "
        }
        return result.isEmpty ? nil : result
    }
    
    var name: String {
        if let variant {
            return variant
        }
        if let autoType {
            return autoType.rawValue
        }
        return "Standard"
    }
}

struct TopValueKey: Equatable, Hashable, Comparable {
    
    let measurement: MeasurementType
    let recordKey: RecordKey
    
    init(measurement: MeasurementType, recordKey: RecordKey) {
        self.measurement = measurement
        self.recordKey = recordKey
    }
    
    init(measurement: MeasurementType,
         autoType: AutoRecordType?,
         variant: String?
    ) {
        self.measurement = measurement
        self.recordKey = RecordKey(autoType: autoType, variant: variant)
    }
    
    static func == (lhs: TopValueKey, rhs: TopValueKey) -> Bool {
        return lhs.measurement == rhs.measurement &&
            lhs.autoType == rhs.autoType &&
        lhs.variant == rhs.variant
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(measurement.rawValue)
        hasher.combine(autoType?.rawValue)
        hasher.combine(variant)
    }
    
    var id: String {
        return "\(measurement.rawValue)-\(autoType?.rawValue ?? "")-\(variant ?? PBVariant.none)"
    }
    
    var autoType: AutoRecordType? {
        return recordKey.autoType
    }
    
    var variant: String? {
        return recordKey.variant
    }
    
    var suffix: String? { recordKey.suffix }
    
    static func < (lhs: TopValueKey, rhs: TopValueKey) -> Bool {
        if lhs.measurement != rhs.measurement {
            return lhs.measurement.name > rhs.measurement.name
        }
        if lhs.variant != rhs.variant {
            return (lhs.variant ?? "") > (rhs.variant ?? "")
        }
        return (lhs.autoType?.rawValue ?? "") > (rhs.autoType?.rawValue ?? "")
    }
}
