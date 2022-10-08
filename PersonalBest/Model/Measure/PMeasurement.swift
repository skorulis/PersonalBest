//Created by Alexander Skorulis on 8/10/2022.

import Foundation

protocol PMeasurement {
        
    var value: Double { get }
    var symbol: String { get }
}

extension Measurement: PMeasurement {
    
    var symbol: String {
        return self.unit.symbol
    }
    
}


