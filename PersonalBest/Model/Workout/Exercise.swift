//Created by Alexander Skorulis on 2/10/2022.

import Foundation

/*
struct Exercise: Codable, Identifiable {
    
    let id: String
    let activityID: String
    var entries: [ExerciseEntry]
    
    init(activity: PBActivity) {
        self.id = UUID().uuidString
        self.activityID = activity.id
        self.entries = [.init()]
    }
    
    func entry(id: String) -> ExerciseEntry {
        guard let index = entries.firstIndex(where: {$0.id == id}) else {
            fatalError("Exercise not in workout \(id)")
        }
        return entries[index]
    }
    
    func indexOf(entry: ExerciseEntry) -> Int {
        guard let index = entries.firstIndex(where: {$0.id == entry.id}) else {
            fatalError("Exercise not in workout \(entry)")
        }
        return index
    }
    
    mutating func replace(entry: ExerciseEntry) {
        let index = indexOf(entry: entry)
        entries[index] = entry
    }
    
}
*/
struct ExerciseEntry: Codable, Identifiable {
    let id: String
    var values: [MeasurementType: Decimal]
    
    init() {
        id = UUID().uuidString
        values = [:]
    }
    
}
