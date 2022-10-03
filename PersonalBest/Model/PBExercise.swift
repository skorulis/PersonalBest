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
    
    
}
