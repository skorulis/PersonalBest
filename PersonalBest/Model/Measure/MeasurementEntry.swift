//Created by Alexander Skorulis on 26/9/2022.

import CryptoKit
import Foundation

struct MeasurementEntry {
    let type: MeasurementType
    let lowerIsBetter: Bool
    let defaultUnit: KnownUnit
    let isRecord: Bool // Whether this field should be considered a record
    
    init(type: MeasurementType,
         isRecord: Bool,
         lowerIsBetter: Bool = false,
         defaultUnit: KnownUnit
    ) {
        self.type = type
        self.isRecord = isRecord
        self.lowerIsBetter = lowerIsBetter
        self.defaultUnit = defaultUnit
    }
}
