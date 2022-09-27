//Created by Alexander Skorulis on 26/9/2022.

import Foundation

/// A single record entry against an activity.
struct ActivityEntry: Codable {
    let date: Date
    let values: [MeasurementType: Decimal]
}

/// List of all the records for an activity
struct ActivityRecords: Codable {
    let activityID: String
    let entries: [ActivityEntry]
}
