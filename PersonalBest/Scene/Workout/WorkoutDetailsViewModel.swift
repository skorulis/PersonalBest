//Created by Alexander Skorulis on 1/10/2022.

import Foundation
import SwiftUI

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
        indexSet.reversed().forEach { value in
            self.workout.exercises.remove(at: value)
        }
    }
    
    func deleteEntry(exercise: Exercise) -> (IndexSet) -> Void {
        return { [unowned self] indexSet in
            var mutableExercise = exercise
            indexSet.forEach { index in
                mutableExercise.entries.remove(at: index)
            }
            if mutableExercise.entries.isEmpty {
                self.workout.remove(exercise: exercise)
            } else {
                self.workout.replace(exercise: mutableExercise)
            }
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
    
    func binding(_ exercise: Exercise) -> Binding<Exercise> {
        return Binding<Exercise> { [unowned self] in
            return self.workout.exercise(id: exercise.id)
        } set: { [unowned self] newValue in
            self.workout.replace(exercise: newValue)
        }
    }
    
    func binding(_ exercise: Exercise, _ entry: ExerciseEntry) -> Binding<ExerciseEntry> {
        let bindingExercise = binding(exercise)
        return Binding<ExerciseEntry> {
            return bindingExercise.wrappedValue.entry(id: entry.id)
        } set: { newValue in
            bindingExercise.wrappedValue.replace(entry: newValue)
        }
    }
    
}
