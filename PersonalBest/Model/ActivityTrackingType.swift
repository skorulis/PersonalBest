//Created by Alexander Skorulis on 29/9/2022.

import Foundation

enum ActivityTrackingType {
    
    case weightlifting
    case cardio
    
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
        }
    }
}
