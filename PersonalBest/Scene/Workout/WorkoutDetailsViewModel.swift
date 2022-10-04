//Created by Alexander Skorulis on 1/10/2022.

import Foundation
import SwiftUI

// MARK: - Memory footprint

final class WorkoutDetailsViewModel: CoordinatedViewModel, ObservableObject {
    
    private let activityService: ActivityService
    
    @Published var workout: PBWorkout {
        didSet {
            try! self.workout.managedObjectContext?.save()
        }
    }
    
    @Published var endDate: Date {
        didSet {
            hasFinished = true
            workout.endDate = endDate
        }
    }
    @Published var hasFinished: Bool
    
    init(workout: PBWorkout,
         activityService: ActivityService
    ) {
        self.workout = workout
        self.activityService = activityService
        self.endDate = workout.endDate ?? Date()
        self.hasFinished = workout.endDate != nil
        super.init()
        self.workout.objectWillChange
            .sink { [unowned self] in
                self.objectWillChange.send()
            }
            .store(in: &subscribers)
    }
    
}


// MARK: - Logic

extension WorkoutDetailsViewModel {
    
    func delete(_ indexSet: IndexSet) {
        indexSet.reversed().forEach { value in
            
            // TODO
            //self.workout.exercises.remove(at: value)
        }
    }
    
    func deleteEntry(exercise: PBExercise) -> (IndexSet) -> Void {
        return { [unowned self] indexSet in
            var mutableSets = exercise.sets
            indexSet.forEach { index in
                mutableSets.remove(at: index)
            }
            if mutableSets.isEmpty {
                self.workout.exercises.remove(exercise)
            } else {
                exercise.sets = mutableSets
            }
            try! exercise.managedObjectContext?.save()
        }
    }
    
    func addSet(exercise: PBExercise) {
        let set = ExerciseEntry()
        var sets = exercise.sets
        sets.append(set)
        exercise.sets = sets
        try! exercise.managedObjectContext?.save()
    }
    
    func addExercise() {
        let path = RootPath.selectWorkoutActivity { [unowned self] activity in
            _ = PBExercise.new(workout: workout, activity: activity)
            try! workout.managedObjectContext?.save()
        }
        coordinator.present(path, style: .sheet)
    }
    
    func binding(_ exercise: PBExercise, _ entry: ExerciseEntry) -> Binding<ExerciseEntry> {
        return Binding<ExerciseEntry> {
            return exercise.entry(id: entry.id)
        } set: { newValue in
            exercise.replace(entry: newValue)
        }
    }

    
}
