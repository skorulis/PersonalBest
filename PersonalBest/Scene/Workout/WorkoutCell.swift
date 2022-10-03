//Created by Alexander Skorulis on 1/10/2022.

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct WorkoutCell {
    
    let workout: PBWorkout
    @Environment(\.factory) private var factory
    
}

// MARK: - Rendering

extension WorkoutCell: View {
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            dateView
            VStack(alignment: .leading) {
                ForEach(Array(workout.exercises)) { exercise in
                    exerciseCounts(exercise)
                }
            }
        }
    }
    
    private var dateView: some View {
        VStack {
            Text(DateFormatter.shortDayName.string(from: workout.startDate))
            Text(DateFormatter.dayOfMonth.string(from: workout.startDate))
                .bold()
        }
    }
    
    private func exerciseCounts(_ exercise: PBExercise) -> some View {
        return VStack(alignment: .leading, spacing: 0) {
            Text("\(exercise.sets.count)x \(exercise.activity.name)")
        }
    }
    
}

// MARK: - Previews

struct WorkoutCell_Previews: PreviewProvider {
    
    static var previews: some View {
        let workout = PBWorkout()
        return WorkoutCell(workout: workout)
    }
}

