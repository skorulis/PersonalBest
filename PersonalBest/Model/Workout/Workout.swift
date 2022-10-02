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
    
    mutating func replace(exercise: Exercise) {
        guard let index = exercises.firstIndex(where: {$0.id == exercise.id}) else {
            return
        }
        exercises[index] = exercise
    }
    
}

struct Exercise: Codable, Identifiable {
    
    let id: String
    let activityID: String
    var entries: [ExerciseEntry]
    
    init(activity: Activity) {
        self.id = UUID().uuidString
        self.activityID = activity.id
        self.entries = [.init()]
    }
    
}

struct ExerciseEntry: Codable, Identifiable {
    let id: String
    let values: [MeasurementType: Decimal]
    
    init() {
        id = UUID().uuidString
        values = [:]
    }
}
