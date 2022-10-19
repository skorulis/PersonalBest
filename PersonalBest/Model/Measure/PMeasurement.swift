//Created by Alexander Skorulis on 8/10/2022.

import Foundation

protocol PMeasurement {
        
    var value: Double { get }
    var symbol: String { get }
    var knownUnit: KnownUnit { get }
    var type: MeasurementType { get }
}

extension Measurement: PMeasurement {
    
    var symbol: String {
        return self.unit.symbol
    }
    
    var knownUnit: KnownUnit {
        return KnownUnit.from(unit: self.unit)
    }
    
    var type: MeasurementType {
        return MeasurementType.type(unit: knownUnit)
    }
    
}


