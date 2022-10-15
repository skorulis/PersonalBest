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
    
    func entry(id: String) -> ExerciseEntry? {
        guard let index = sets.firstIndex(where: {$0.id == id}) else {
            return nil
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
    
    func total(_ measurement: MeasurementType) -> Double {
        return sets.map { $0.values[measurement] ?? 0}.reduce(0, +)
    }
    
    
    var totlaVolume: PMeasurement {
        switch activity.trackingType {
        case .reps:
            let reps = total(.reps)
            return Measurement<UnitReps>(value: reps, unit: .reps)
        case .time:
            let time = total(.time)
            return Measurement<UnitDuration>(value: time, unit: .seconds)
        case .weightlifting:
            let unit = activity.currentUnit(.weight)
            let vol: Double = sets.map { entry in
                let value = entry.values[.weight] ?? 0
                let weight = MeasurementType.weight.convert(value: value, to: unit)
                let reps = entry.values[.reps] ?? 0
                return weight * reps
            }
            .reduce(0, +)
            
            return Measurement<UnitMass>(value: vol, unit: unit.unit as! UnitMass)
        case .cardio:
            let dist = total(.distance)
            return Measurement<UnitLength>(value: dist, unit: .meters)
        }
    }
    
}
