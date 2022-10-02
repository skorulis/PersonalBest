//Created by Alexander Skorulis on 1/10/2022.

import ASKCore
import Foundation

final class WorkoutListViewModel: CoordinatedViewModel, ObservableObject {
    
    private let store: WorkoutStore
    
    init(store: WorkoutStore) {
        self.store = store
        super.init()
        
        store.objectWillChange.sink { [unowned self] _ in
            self.objectWillChange.send()
        }
        .store(in: &subscribers)
    }
    
}

// MARK: - Computed values

extension WorkoutListViewModel {
    
    var workouts: [Workout] {
        return store.workouts.reversed()
    }
    
}

// MARK: - Logic

extension WorkoutListViewModel {
    
    func add() {
        let workout = Workout.new()
        store.workouts.append(workout)
        coordinator.push(.workout(workout))
    }
    
    func select(workout: Workout) -> () -> Void {
        return { [unowned self] in
            self.coordinator.push(.workout(workout))
        }
    }
    
    func delete(indexes: IndexSet) {
        let ids = indexes.map { self.workouts[$0].id }
        
        store.workouts = store.workouts.filter { ids.contains($0.id) }
    }
    
    static func group(workouts: [Workout]) -> [MonthWorkouts] {
        var dict: [Date: [Workout]] = [:]
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
        let workouts: [Workout]
    }
}
