//Created by Alexander Skorulis on 26/9/2022.

import CryptoKit
import Foundation

struct MeasurementEntry: Codable {
    let type: MeasurementType
    let lowerIsBetter: Bool
    let defaultUnit: UnitType
    let isRecord: Bool // Whether this field should be considered a record
    
    init(type: MeasurementType,
         isRecord: Bool,
         lowerIsBetter: Bool = false,
         defaultUnit: UnitType
    ) {
        self.type = type
        self.isRecord = isRecord
        self.lowerIsBetter = lowerIsBetter
        self.defaultUnit = defaultUnit
    }
}
