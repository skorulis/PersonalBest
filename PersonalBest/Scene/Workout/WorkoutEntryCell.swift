//Created by Alexander Skorulis on 2/10/2022.

import ASSwiftUI
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct WorkoutEntryCell {
    
    let activity: Activity
    let exercise: Exercise
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
        let activity = Activity(systemName: "test", tracking: .weightlifting)
        let exercise = Exercise(activity: activity)
        
        StatefulPreviewWrapper(exercise.entries[0]) { entry in
            WorkoutEntryCell(activity: activity, exercise: exercise, entry: entry)
        }
    }
}

