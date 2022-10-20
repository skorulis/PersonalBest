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
            middleContent
            Spacer()
        }
    }
    
    private var middleContent: some View {
        VStack(alignment: .leading) {
            maybeInProgress
            maybeEmptyLabel
            ForEach(Array(workout.sortedExercises)) { exercise in
                exerciseCounts(exercise)
            }
            maybeTime
        }
    }
    
    private var dateView: some View {
        VStack {
            Text(DateFormatter.shortDayName.string(from: workout.startDate))
            Text(DateFormatter.dayOfMonth.string(from: workout.startDate))
                .bold()
        }
    }
    
    @ViewBuilder
    private var maybeInProgress: some View {
        if workout.endDate == nil {
            Text("In progress")
                .bold()
        }
    }
    
    @ViewBuilder
    private var maybeEmptyLabel: some View {
        if workout.exercises.isEmpty {
            Text("No exercises")
        }
    }
    
    private func exerciseCounts(_ exercise: PBExercise) -> some View {
        return VStack(alignment: .leading, spacing: 0) {
            Text("\(exercise.sets.count)x \(exercise.activity.name)")
        }
    }
    
    @ViewBuilder
    private var maybeTime: some View {
        if let minutes = workout.totalMinutes {
            VStack {
                Text("\(minutes) Minutes")
                    .typography(.smallBody)
            }
            
        }
    }
    
}

// MARK: - Previews

struct WorkoutCell_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = IOC()
        let context = ioc.resolve(CoreDataStore.self).mainContext
        let workout = PBWorkout.new(context: context)
        let finishedWorkout = PBWorkout.new(context: context)
        finishedWorkout.endDate = Date(timeIntervalSinceNow: 10000)
        
        return VStack {
            WorkoutCell(workout: workout)
                .environment(\.factory, ioc)
            
            WorkoutCell(workout: finishedWorkout)
                .environment(\.factory, ioc)
        }
    }
}

