//Created by Alexander Skorulis on 26/9/2022.

import Foundation

/// Describes an activity that can be performed
struct Activity: Codable, Identifiable {
    let id: String
    let name: String
    let measurements: [MeasurementEntry]
    
    init(name: String, measurements: [MeasurementEntry]) {
        self.name = name
        self.measurements = measurements
        self.id = UUID().uuidString
    }
    
    init(name: String, measureTypes: [MeasurementType]) {
        self.name = name
        self.measurements = measureTypes.map { .init(type: $0) }
        self.id = UUID().uuidString
    }
}

struct MeasurementEntry: Codable {
    let type: MeasurementType
    let lowerIsBetter: Bool
    
    init(type: MeasurementType, lowerIsBetter: Bool = false) {
        self.type = type
        self.lowerIsBetter = lowerIsBetter
    }
}
