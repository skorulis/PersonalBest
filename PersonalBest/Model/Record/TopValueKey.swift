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
}

struct TopValueKey: Equatable, Hashable {
    let measurement: MeasurementType
    // TODO: Maybe merge with record
    let autoType: AutoRecordType?
    let variant: String?
    
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
        return "\(measurement.rawValue)-\(autoType?.rawValue ?? "")-\(variant ?? "")"
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
}
