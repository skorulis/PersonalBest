//Created by Alexander Skorulis on 1/10/2022.

import Foundation

// MARK: - Memory footprint

final class WorkoutDetailsViewModel: CoordinatedViewModel, ObservableObject {
    
    private let workoutStore: WorkoutStore
    @Published var workout: Workout {
        didSet {
            workoutStore.update(workout: workout)
        }
    }
    
    @Published var endDate: Date {
        didSet {
            hasFinished = true
            workout.endDate = endDate
        }
    }
    @Published var hasFinished: Bool
    
    init(workout: Workout,
         workoutStore: WorkoutStore
    ) {
        self.workout = workout
        self.workoutStore = workoutStore
        self.endDate = workout.endDate ?? Date()
        self.hasFinished = workout.endDate != nil
    }
    
}
