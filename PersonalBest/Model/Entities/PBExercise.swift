//Created by Alexander Skorulis on 3/10/2022.

import Foundation
import CoreData

@objc(PBExercise)
public class PBExercise: NSManagedObject, Identifiable {
 
    @nonobjc class func fetch() -> NSFetchRequest<PBExercise> {
        return NSFetchRequest<PBExercise>(entityName: "PBExercise")
    }
    
    @NSManaged public var setsData: Data
    @NSManaged public var number: Int16
    
    var sets: [ExerciseEntry] {
        get {
            let decoded = try? JSONDecoder().decode([ExerciseEntry].self, from: setsData)
            return decoded ?? []
        }
        set {
            setsData = try! JSONEncoder().encode(newValue)
        }
    }
    
    @NSManaged public var activity: PBActivity
    @NSManaged public var workout: PBWorkout
    
    static func new(workout: PBWorkout, activity: PBActivity) -> PBExercise {
        let exercise = PBExercise(context: workout.managedObjectContext!)
        exercise.number = Int16(workout.exercises.count) + 1
        exercise.workout = workout
        exercise.activity = activity
        exercise.sets = [.init()]
        
        return exercise
    }
    
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
