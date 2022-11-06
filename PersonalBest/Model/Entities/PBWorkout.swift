//Created by Alexander Skorulis on 3/10/2022.

import Foundation
import CoreData

@objc(PBWorkout)
public class PBWorkout: NSManagedObject, Identifiable {
 
    @nonobjc class func fetch() -> NSFetchRequest<PBWorkout> {
        return NSFetchRequest<PBWorkout>(entityName: "PBWorkout")
    }
    
    @NSManaged public var startDate: Date
    @NSManaged public var endDate: Date?
    @NSManaged public var notes: String?
    @NSManaged public var versionID: String
    
    @NSManaged public var exercises: Set<PBExercise>
    @NSManaged public var records: Set<PBRecordEntry>
    
    static func new(context: NSManagedObjectContext) -> PBWorkout {
        let workout = PBWorkout(context: context)
        workout.startDate = Date()
        workout.versionID = UUID().uuidString
        return workout
    }
    
    var sortedExercises: [PBExercise] {
        let query = PBExercise.fetch()
        query.sortDescriptors = [.init(key: "number", ascending: true)]
        query.predicate = NSPredicate(format: "workout == %@", self)
        return try! self.managedObjectContext!.fetch(query)
    }
    
    var actvitySets: [PBActivity: [PRecordEntry]] {
        var result: [PBActivity: [PRecordEntry]] = [:]
        for exercise in exercises {
            let sets = exercise.sets
            var array = result[exercise.activity] ?? []
            for set in sets {
                let entry = RecordEntry(date: self.startDate,
                                        variantName: set.variant ?? PBVariant.none,
                                        entryValues: set.values,
                                        autoType: nil)
                array.append(entry)
            }
            result[exercise.activity] = array
        }
        
        return result
    }
    
    var totalMinutes: Int? {
        guard let endDate else { return nil }
        let minutes = endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970
        return Int(minutes / 60)
    }
    
}
