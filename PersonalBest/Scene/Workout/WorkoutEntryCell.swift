//Created by Alexander Skorulis on 2/10/2022.

import ASSwiftUI
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct WorkoutEntryCell {
    
    let exercise: PBExercise
    @Binding var entry: ExerciseEntry?
    @FocusState var focusedField: WorkoutFocus?
    
    init(exercise: PBExercise,
         entry: Binding<ExerciseEntry?>,
         focus: FocusState<WorkoutFocus?>
    ) {
        self.exercise = exercise
        _entry = entry
        _focusedField = focus
    }
    
}

// MARK: - Rendering

extension WorkoutEntryCell: View {
    
    var body: some View {
        if entry == nil {
            EmptyView()
        } else {
            HStack {
                setIndexView
                fields
                maybeVariantPicker
            }
        }
    }
    
    @ViewBuilder
    private var fields: some View {
        switch activity.trackingType {
        case .cardio:
            VStack(spacing: 0) {
                field(type: .distance)
                field(type: .time)
            }
        default:
            horizontalFields
        }
    }
    
    private var horizontalFields: some View {
        ForEach(activity.measurementTypes) { type in
            field(type: type)
        }
    }
    
    private var setIndexView: some View {
        Text("\(setIndex + 1)")
            .typography(.caption)
            .foregroundColor(isComplete ? .black : .black.opacity(0.5))
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
            TimeField(value: binding(type: type))
        default:
            VStack(alignment: .leading, spacing: 0) {
                Text(type.name)
                    .font(.caption)
                DecimalField(type: type, value: binding(type: type))
                    .focused($focusedField, equals: .setEntry(exercise.number, setIndex: setIndex, measurement: type))
            }
            
        }
    }
    
    var activity: PBActivity {
        return exercise.activity
    }
    
    var setIndex: Int {
        exercise.indexOf(entry: entry!)
    }
    
    @ViewBuilder
    private var maybeVariantPicker: some View {
        Text("Variant")
    }
}

// MARK: - Logic

extension WorkoutEntryCell {
    
    func binding(type: MeasurementType) -> Binding<Double?> {
        return Binding<Double?> {
            return self.entry!.values[type]
        } set: { newValue in
            self.entry!.values[type] = newValue
        }
    }
    
    var isComplete: Bool {
        for measure in activity.measurementTypes {
            guard let value = entry?.values[measure] else {
                return false
            }
            return value > 0
        }
        return true
    }
    
}

// MARK: - Previews

struct WorkoutEntryCell_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = IOC()
        let context = ioc.resolve(CoreDataStore.self).mainContext
        
        let workout = PBWorkout.new(context: context)
        
        let exercise1 = PreviewData.bodyExercise(workout)
        let exercise2 = PreviewData.weightExercise(workout)
        let exercise3 = PreviewData.cardioExercise(workout)
        
        return VStack {
            StatefulPreviewWrapper(exercise1.sets.first!) { entry in
                WorkoutEntryCell(exercise: exercise1, entry: entry, focus: .init())
            }
            
            StatefulPreviewWrapper(exercise2.sets.first!) { entry in
                WorkoutEntryCell(exercise: exercise2, entry: entry, focus: .init())
            }
            
            StatefulPreviewWrapper(exercise3.sets.first!) { entry in
                WorkoutEntryCell(exercise: exercise3, entry: entry, focus: .init())
            }
        }
    }
}

