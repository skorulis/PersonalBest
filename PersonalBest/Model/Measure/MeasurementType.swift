//Created by Alexander Skorulis on 27/9/2022.

import Foundation

enum MeasurementType: String, Codable, Identifiable, CaseIterable {
    case reps
    case weight
    case distance
    case time
    
    var id: String { rawValue }
    
    var unitOptions: [KnownUnit] {
        switch self {
        case .reps:
            return [.reps]
        case .distance:
            return [
                .meters,
                .kilometers
            ]
        case .weight:
            return [
                .grams,
                .kilograms
            ]
        case .time:
            return [.seconds]
        }
    }
    
    var defaultUnit: KnownUnit {
        switch self {
        case .reps:
            return .reps
        case .distance:
            return .meters
        case .weight:
            return .grams
        case .time:
            return .seconds
        }
    }
    
    static func type(unit: KnownUnit) -> MeasurementType {
        guard let result = MeasurementType.allCases.first(where: {$0.unitOptions.contains(unit)}) else {
            fatalError("Could not find measurement type for unit \(unit)")
        }
        return result
    }
    
    var name: String {
        return self.rawValue.capitalized
    }
    
    static func convert(value: Double, from: KnownUnit, to: KnownUnit) -> Double {
        let measure = Measurement(value: value, unit: from.unit)
        return measure.converted(to: to.unit).value
    }
    
    func convert(value: Double, from: KnownUnit) -> Double {
        return Self.convert(value: value, from: from, to: self.defaultUnit)
    }
    
    func convert(value: Double, to: KnownUnit) -> Double {
        return Self.convert(value: value, from: self.defaultUnit, to: to)
    }
    
}
