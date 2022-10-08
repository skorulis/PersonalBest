//Created by Alexander Skorulis on 27/9/2022.

import Foundation

enum MeasurementType: String, Codable, Identifiable {
    case reps
    case weight
    case distance
    case time
    
    var id: String { rawValue }
    
    var unitOptions: [UnitType] {
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
                .kilograms
            ]
        case .time:
            return [.seconds]
        }
    }
    
    var defaultUnit: UnitType {
        switch self {
        case .reps:
            return .reps
        case .distance:
            return .kilometers
        case .weight:
            return .kilograms
        case .time:
            return .seconds
        }
    }
    
    var name: String {
        return self.rawValue.capitalized
    }
}
