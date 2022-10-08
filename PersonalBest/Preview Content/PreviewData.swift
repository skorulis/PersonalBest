//Created by Alexander Skorulis on 8/10/2022.

import Foundation
import CoreData

struct PreviewData {
    
    static func weightActivity(_ context: NSManagedObjectContext) -> PBActivity {
        return PBActivity.new(context: context, name: "Weights", tracking: .weightlifting)
    }
    
    static func bodyActivity(_ context: NSManagedObjectContext) -> PBActivity {
        return PBActivity.new(context: context, name: "Body", tracking: .reps)
    }
    
    static func weightExercise(_ workout: PBWorkout) -> PBExercise {
        return PBExercise.new(workout: workout, activity: weightActivity(workout.managedObjectContext!))
    }
    
    static func bodyExercise(_ workout: PBWorkout) -> PBExercise {
        return PBExercise.new(workout: workout, activity: bodyActivity(workout.managedObjectContext!))
    }
    
}
