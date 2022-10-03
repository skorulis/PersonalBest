//Created by Alexander Skorulis on 3/10/2022.

import Foundation
import CoreData

@objc(PBExercise)
public class PBExercise: NSManagedObject, Identifiable {
 
    @nonobjc class func fetch() -> NSFetchRequest<PBExercise> {
        return NSFetchRequest<PBExercise>(entityName: "PBExercise")
    }
    
    @NSManaged public var setsData: Data
    
    var sets: [ExerciseEntry] {
        get {
            try! JSONDecoder().decode([ExerciseEntry].self, from: setsData)
        }
        set {
            setsData = try! JSONEncoder().encode(newValue)
        }
    }
    
    @NSManaged public var activity: PBActivity
    @NSManaged public var workout: PBWorkout
    
    func entry(id: String) -> ExerciseEntry {
        guard let index = sets.firstIndex(where: {$0.id == id}) else {
            fatalError("Exercise not in workout \(id)")
        }
        return sets[index]
    }
    
    func indexOf(entry: ExerciseEntry) -> Int {
        guard let index = sets.firstIndex(where: {$0.id == entry.id}) else {
            fatalError("Exercise not in workout \(entry)")
        }
        return index
    }
    
    func replace(entry: ExerciseEntry) {
        let index = indexOf(entry: entry)
        sets[index] = entry
    }
    
    
}