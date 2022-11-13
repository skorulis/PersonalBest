//Created by Alexander Skorulis on 29/9/2022.

import Foundation

enum ActivityTrackingType: String, CaseIterable, Identifiable {
    
    case weightlifting
    case cardio
    case reps
    case time
    
    var measurements: [MeasurementEntry] {
        switch self {
        case .weightlifting:
            return [
                .init(type: .weight, isRecord: true, defaultUnit: .kilograms),
                .init(type: .reps, isRecord: false, defaultUnit: .reps)
            ]
        case .cardio:
            return [
                .init(type: .distance, isRecord: true, defaultUnit: .kilometers),
                .init(type: .time, isRecord: true, defaultUnit: .seconds)
            ]
        case .reps:
            return [
                .init(type: .reps, isRecord: true, defaultUnit: .reps)
            ]
        case .time:
            return [
                .init(type: .time, isRecord: true, defaultUnit: .seconds)
            ]
        }
    }
    
    var id: String { rawValue }
    
    func unit(for type: MeasurementType) -> KnownUnit {
        switch (self, type) {
        case (.weightlifting, .weight):
            return .kilograms
        case (.cardio, .distance):
            return .kilometers
        default:
            return type.defaultUnit
        }
    }
    
    var primaryMeasure: MeasurementType {
        switch self {
        case .weightlifting: return .weight
        case .cardio: return .distance
        case .reps: return .reps
        case .time: return .time
        }
    }
    
    var name: String {
        switch self {
        case .weightlifting: return "Weights"
        case .cardio: return "Cardio"
        case .reps: return "Reps"
        case .time: return "Time"
        }
    }
    
}
