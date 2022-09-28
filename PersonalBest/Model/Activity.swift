//Created by Alexander Skorulis on 26/9/2022.

import CryptoKit
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
    
    init(systemName: String, measureTypes: [MeasurementType]) {
        self.name = systemName
        self.measurements = measureTypes.map { .init(type: $0) }
        let data = systemName.data(using: .utf8)!
        let hash = SHA256.hash(data: data)
        self.id = hash.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    var measurementTypes: [MeasurementType] {
        measurements.map { $0.type }
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
