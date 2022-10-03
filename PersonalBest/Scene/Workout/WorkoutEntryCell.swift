//Created by Alexander Skorulis on 2/10/2022.

import ASSwiftUI
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct WorkoutEntryCell {
    
    let exercise: PBExercise
    @Binding var entry: ExerciseEntry
    
}

// MARK: - Rendering

extension WorkoutEntryCell: View {
    
    var body: some View {
        HStack {
            setIndex
            ForEach(activity.measurementTypes) { type in
                field(type: type)
            }
        }
    }
    
    private var setIndex: some View {
        Text("\(exercise.indexOf(entry: entry))")
            .frame(minWidth: 30, minHeight: 30)
            .background(
                Circle()
                    .stroke(Color.black)
            )
    }
    
    @ViewBuilder
    private func field(type: MeasurementType) -> some View {
        switch type {
        case .time:
            Text("TODO")
        default:
            DecimalField(type: type, value: binding(type: type))
        }
    }
    
    var activity: PBActivity {
        return exercise.activity
    }
}

// MARK: - Logic

extension WorkoutEntryCell {
    
    func binding(type: MeasurementType) -> Binding<Decimal?> {
        return Binding<Decimal?> {
            return self.entry.values[type]
        } set: { newValue in
            self.entry.values[type] = newValue
        }
    }
    
}

// MARK: - Previews

struct WorkoutEntryCell_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = IOC()
        let context = ioc.resolve(CoreDataStore.self).mainContext
        let activity = PBActivity()
        activity.name = "TEST"
        activity.trackingType = .weightlifting
        
        let workout = PBWorkout(context: context)
        workout.startDate = Date()
        
        let exercise = PBExercise(context: context)
        exercise.activity = activity
        exercise.workout = workout
        
        return StatefulPreviewWrapper(ExerciseEntry()) { entry in
            WorkoutEntryCell(exercise: exercise, entry: entry)
        }
    }
}

