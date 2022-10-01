//Created by Alexander Skorulis on 1/10/2022.

import Foundation

struct Workout: Codable, Identifiable {
    
    let id: String
    var startDate: Date
    var endDate: Date?
    var notes: String
    
    var exercises: [Exercise]
    
    static func new() -> Workout {
        return Workout(id: UUID().uuidString,
                       startDate: Date(),
                       notes: "",
                       exercises: []
        )
    }
    
}

struct Exercise: Codable {
    
    let activityID: String
    let entries: [ExerciseEntry]
    
}

struct ExerciseEntry: Codable {
    let id: String
    let values: [MeasurementType: Decimal]
}
