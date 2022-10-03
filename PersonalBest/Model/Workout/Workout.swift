//Created by Alexander Skorulis on 1/10/2022.

import Foundation
import SwiftUI
/*
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
        let index = indexOf(exercise: exercise)
        exercises[index] = exercise
    }
    
    mutating func remove(exercise: Exercise) {
        let index = indexOf(exercise: exercise)
        exercises.remove(at: index)
    }
    
    func indexOf(exercise: Exercise) -> Int {
        guard let index = exercises.firstIndex(where: {$0.id == exercise.id}) else {
            fatalError("Exercise not in workout \(exercise)")
        }
        return index
    }
    
    func exercise(id: String) -> Exercise {
        guard let index = exercises.firstIndex(where: {$0.id == id}) else {
            fatalError("Exercise not in workout \(id)")
        }
        return exercises[index]
    }
    
}
*/
