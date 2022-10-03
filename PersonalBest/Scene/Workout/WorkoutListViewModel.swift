//Created by Alexander Skorulis on 1/10/2022.

import ASKCore
import Foundation

final class WorkoutListViewModel: CoordinatedViewModel, ObservableObject {
    
    private let coreDataStore: CoreDataStore
    
    init(coreDataStore: CoreDataStore) {
        self.coreDataStore = coreDataStore
        super.init()
        
    }
    
}

// MARK: - Computed values

extension WorkoutListViewModel {
    
    var workouts: [PBWorkout] {
        return [] //TODO
    }
    
}

// MARK: - Logic

extension WorkoutListViewModel {
    
    func add() {
        let workout = PBWorkout(context: coreDataStore.mainContext)
        workout.startDate = Date()
        try! workout.managedObjectContext?.save()
        coordinator.push(.workout(workout))
    }
    
    func select(workout: PBWorkout) -> () -> Void {
        return { [unowned self] in
            self.coordinator.push(.workout(workout))
        }
    }
    
    func delete(indexes: IndexSet) {
        // TODO
    }
    
    static func group(workouts: [PBWorkout]) -> [MonthWorkouts] {
        var dict: [Date: [PBWorkout]] = [:]
        for workout in workouts {
            let month = workout.startDate.startOfMonth
            if dict[month] == nil {
                dict[month] = [workout]
            } else {
                dict[month]?.append(workout)
            }
        }
        let array = dict.map { (key, value) in
            return MonthWorkouts(month: key, workouts: value)
        }
        return array.sorted { m1, m2 in
            return m1.month < m2.month
        }
    }
    
}

// MARK: - Inner types

extension WorkoutListViewModel {
    struct MonthWorkouts {
        let month: Date
        let workouts: [PBWorkout]
    }
}
