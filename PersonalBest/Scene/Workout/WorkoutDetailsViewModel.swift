//Created by Alexander Skorulis on 1/10/2022.

import Foundation
import SwiftUI

// MARK: - Memory footprint

final class WorkoutDetailsViewModel: CoordinatedViewModel, ObservableObject {
    
    private let activityService: ActivityService
    private let breakdownService: BreakdownService
    private let recordAccess: RecordEntryAccess
    
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
         activityService: ActivityService,
         breakdownService: BreakdownService,
         recordAccess: RecordEntryAccess
    ) {
        self.workout = workout
        self.activityService = activityService
        self.breakdownService = breakdownService
        self.recordAccess = recordAccess
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
            let exercise = PBExercise.new(workout: workout, activity: activity)
            let firstMeasure = exercise.activity.measurementTypes.first!
            self.focusPublisher = .setEntry(exercise.number, setIndex: 0, measurement: firstMeasure)
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
            self.save()
        }
    }
    
    func save() {
        workout.versionID = UUID().uuidString
        try! workout.managedObjectContext?.save()
    }
    
    func finish() {
        self.endDate = Date()
        let setMap = workout.actvitySets
        
        for (act, value) in setMap {
            switch act.trackingType {
            case .weightlifting:
                let breakdown = breakdownService.repWeightBreakdown(records: value, activity: act)
                createRecords(breakdown: breakdown)
            default:
                let breakdown = breakdownService.singleBreakdown(type: act.primaryMeasure, records: value, activity: act)
                createRecords(breakdown: breakdown)
            }
        }
        
        save()
    }
    
    private func createRecords(breakdown: RepWeightBreakdown) {
        for (variant, repValues) in breakdown.repValues {
            for (repCount, values) in repValues {
                guard let top = values.last else {
                    continue
                }
                
                // TODO: Only create records if beating previous?
                let variant = PBVariant.find(context: workout.managedObjectContext!, name: variant)
                _ = PBRecordEntry.new(activity: breakdown.activity,
                                      date: top.date,
                                      variant: variant,
                                      values: [.weight: top.value, .reps: Double(repCount)]
                )
            }
        }
    }
    
    private func createRecords(breakdown: SimpleRecordsBreakdown) {
        for (variant, values) in breakdown.values {
            guard let top = values.last else {
                continue
            }
            
            // TODO: Only create records if beating previous?
            let variant = PBVariant.find(context: workout.managedObjectContext!, name: variant)
            _ = PBRecordEntry.new(activity: breakdown.activity,
                                  date: top.date,
                                  variant: variant,
                                  values: [breakdown.activity.primaryMeasure: top.value]
            )
            
        }
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
