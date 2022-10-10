//Created by Alexander Skorulis on 7/10/2022.

import Foundation

protocol PRecordEntry {
    var date: Date { get }
    var variantName: String? { get }
    var entryValues: [MeasurementType: Double] { get }
}

/// record entry not linked to core data
struct RecordEntry: PRecordEntry {
    
    let date: Date
    let variantName: String?
    let entryValues: [MeasurementType: Double]
    
}
