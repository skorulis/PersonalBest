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
    
    @NSManaged public var exercises: Set<PBExercise>
    
}
