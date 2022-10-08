//Created by Alexander Skorulis on 1/10/2022.

import Foundation
import SwiftUI

// MARK: - Memory footprint

final class WorkoutDetailsViewModel: CoordinatedViewModel, ObservableObject {
    
    private let activityService: ActivityService
    
    @Published var workout: PBWorkout
    @Published var showingDeletePrompt: Bool = false
    @Published var focusPublisher: WorkoutFocus?
    
    @Published var endDate: Date {
        didSet {
            hasFinished = true
            workout.endDate = endDate
            self.save()
        }
    }
    
    @Published var startDate: Date {
        didSet {
            workout.startDate = startDate
            self.save()
        }
    }
    
    @Published var hasFinished: Bool
    
    init(workout: PBWorkout,
         activityService: ActivityService
    ) {
        self.workout = workout
        self.activityService = activityService
        self.endDate = workout.endDate ?? Date()
        self.startDate = workout.startDate
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
            let exercise = workout.sortedExercises[value]
            workout.exercises.remove(exercise)
            workout.managedObjectContext?.delete(exercise)
            self.save()
        }
    }
    
    func deleteEntry(exercise: PBExercise) -> (IndexSet) -> Void {
        return { [unowned self] indexSet in
            var mutableSets = exercise.sets
            indexSet.forEach { index in
                mutableSets.remove(at: index)
            }
            if mutableSets.isEmpty {
                workout.exercises.remove(exercise)
                workout.managedObjectContext?.delete(exercise)
            } else {
                exercise.sets = mutableSets
            }
            self.save()
            self.objectWillChange.send()
        }
    }
    
    func addSet(exercise: PBExercise) {
        let set = ExerciseEntry()
        var sets = exercise.sets
        sets.append(set)
        exercise.sets = sets
        self.save()
        let firstMeasure = exercise.activity.measurementTypes.first!
        self.focusPublisher = .setEntry(exercise.number, setIndex: sets.count-1, measurement: firstMeasure)
    }
    
    func addExercise() {
        let path = RootPath.selectWorkoutActivity { [unowned self] activity in
            _ = PBExercise.new(workout: workout, activity: activity)
            self.save()
        }
        coordinator.present(path, style: .sheet)
    }
    
    func binding(_ exercise: PBExercise, _ entry: ExerciseEntry) -> Binding<ExerciseEntry?> {
        return Binding<ExerciseEntry?> {
            return exercise.entry(id: entry.id)
        } set: { newValue in
            exercise.replace(entry: newValue!)
            self.objectWillChange.send()
        }
    }
    
    func save() {
        workout.versionID = UUID().uuidString
        try! workout.managedObjectContext?.save()
    }
    
    func finish() {
        self.endDate = Date()
        
        // TODO: Create new records
        
        
        save()
    }
    
    func delete() {
        showingDeletePrompt = true
    }
    
    func confirmDelete() {
        workout.managedObjectContext?.delete(workout)
        try! workout.managedObjectContext?.save()
        self.back()
    }

    
}
