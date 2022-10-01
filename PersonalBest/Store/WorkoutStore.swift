//Created by Alexander Skorulis on 1/10/2022.

import ASKCore
import Foundation

final class WorkoutStore: ObservableObject {

    private static let storageKey = "RecordsStore.records"
    private let keyValueStore: PKeyValueStore
    
    @Published var workouts: [Workout] {
        didSet {
            try! keyValueStore.set(codable: workouts, forKey: Self.storageKey)
        }
    }
    
    init(keyValueStore: PKeyValueStore) {
        self.keyValueStore = keyValueStore
        workouts = (try? keyValueStore .codable(forKey: Self.storageKey)) ?? []
    }
    
}

// MARK: - Logic

extension WorkoutStore {
    
    func update(workout: Workout) {
        guard let index = workouts.firstIndex(where: {$0.id == workout.id}) else {
            return
        }
        workouts[index] = workout
    }
}
