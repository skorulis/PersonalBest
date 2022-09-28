//Created by Alexander Skorulis on 26/9/2022.

import Foundation

/// A single record entry against an activity.
struct ActivityEntry: Codable, Identifiable {
    let id: String
    let date: Date
    let values: [MeasurementType: Decimal]
    
    init(date: Date, values: [MeasurementType: Decimal]) {
        self.date = date
        self.values = values
        self.id = UUID().uuidString
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
}
