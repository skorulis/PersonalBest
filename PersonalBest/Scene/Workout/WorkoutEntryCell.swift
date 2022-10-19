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
            VStack {
                HStack {
                    setIndexView
                    fields
                }
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
                Text(fieldName(type: type))
                    .font(.caption)
                DecimalField(type: type, value: binding(type: type))
                    //.focused($focusedField, equals: .setEntry(exercise.number, setIndex: setIndex, measurement: type))
            }
        }
    }
    
    func fieldName(type: MeasurementType) -> String {
        if type.unitOptions.count == 1 {
            return type.name
        } else {
            return "\(type.name) (\(exercise.activity.currentUnit(type).symbolString))"
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
        if activity.variants.count > 0 {
            Picker("Variant", selection: variantBinding) {
                ForEach(variantOptions, id: \.self) { variant in
                    Text(variant)
                        .tag(variant)
                }
            }
            .pickerStyle(.menu)
        }
    }
}

// MARK: - Logic

extension WorkoutEntryCell {
    
    func binding(type: MeasurementType) -> Binding<Double?> {
        return Binding<Double?> {
            guard let value = self.entry?.values[type] else {
                return nil
            }
            return type.convert(value: value, to: activity.currentUnit(type))
        } set: { newValue in
            guard let value = newValue else {
                self.entry!.values[type] = nil
                return
            }
            self.entry!.values[type] = type.convert(value: value, from: activity.currentUnit(type))
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
    
    var variantOptions: [String] {
        return [PBVariant.none] + activity.variants.map { $0.name }
    }
    
    var variantBinding: Binding<String> {
        return Binding<String> {
            return entry?.variant ?? PBVariant.none
        } set: { newValue in
            if newValue == PBVariant.none {
                entry?.variant = nil
            } else {
                entry?.variant = newValue
            }
        }
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

