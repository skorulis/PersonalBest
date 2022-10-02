//Created by Alexander Skorulis on 1/10/2022.

import Foundation

// MARK: - Memory footprint

final class WorkoutDetailsViewModel: CoordinatedViewModel, ObservableObject {
    
    private let workoutStore: WorkoutStore
    private let activityService: ActivityService
    
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
         workoutStore: WorkoutStore,
         activityService: ActivityService
    ) {
        self.workout = workout
        self.workoutStore = workoutStore
        self.activityService = activityService
        self.endDate = workout.endDate ?? Date()
        self.hasFinished = workout.endDate != nil
    }
    
}


// MARK: - Logic

extension WorkoutDetailsViewModel {
    
    func activity(id: String) -> Activity {
        return activityService.activity(id: id)!
    }
    
    func delete(_ indexSet: IndexSet) {
        print("Delete \(indexSet)")
        indexSet.forEach { value in
            print("Index \(value)")
        }
    }
    
    func deleteEntry(exercise: Exercise) -> (IndexSet) -> Void {
        return { indexSet in
            var mutableExercise = exercise
            indexSet.forEach { index in
                print("Remove entry \(index)")
                mutableExercise.entries.remove(at: index)
            }
            self.workout.replace(exercise: mutableExercise)
        }
    }
    
    func addSet(exercise: Exercise) {
        let set = ExerciseEntry()
        var mutableExercise = exercise
        mutableExercise.entries.append(set)
        self.workout.replace(exercise: mutableExercise)
    }
    
    func addExercise() {
        let path = RootPath.selectWorkoutActivity { [unowned self] activity in
            let exercise = Exercise(activity: activity)
            self.workout.exercises.append(exercise)
        }
        coordinator.present(path, style: .sheet)
    }
    
}
