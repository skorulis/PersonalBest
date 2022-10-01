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
}
