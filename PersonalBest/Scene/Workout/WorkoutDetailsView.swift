//Created by Alexander Skorulis on 1/10/2022.

import ASSwiftUI
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct WorkoutDetailsView {
    @StateObject var viewModel: WorkoutDetailsViewModel
}

// MARK: - Rendering

extension WorkoutDetailsView: View {
    
    var body: some View {
        ListTemplate(nav: nav, content: content)
    }
    
    private func nav() -> some View {
        NavBar(left: BarButtonItem.back(viewModel.back),
               mid: BarButtonItem.title("Workout"))
    }
    
    private func content() -> some View {
        Group {
            DatePicker(selection: $viewModel.workout.startDate, displayedComponents: [.date, .hourAndMinute]) {
                Text("Start date")
            }
            
            DatePicker(selection: $viewModel.endDate, displayedComponents: [.date, .hourAndMinute]) {
                Text("End date")
            }
            
            exerciseList
            
            Button(action: viewModel.addExercise) {
                Text("Add exercise")
            }
        }
        .padding(.horizontal, 16)
    }
    
    private var exerciseList: some View {
        ForEach(viewModel.workout.exercises) { exercise in
            exerciseCell(exercise)
        }
        .onDelete(perform: viewModel.delete)
    }
    
    @ViewBuilder
    private func exerciseCell(_ exercise: Exercise) -> some View {
        Text(viewModel.activity(id: exercise.activityID).name)
        ForEach(exercise.entries) { entry in
            Text("Entry")
        }
        .onDelete(perform: viewModel.deleteEntry(exercise: exercise))
        Button(action: {viewModel.addSet(exercise: exercise)}) {
            Text("Add set")
        }
        .deleteDisabled(true)
        
    }
}

// MARK: - Previews

struct WorkoutDetailsView_Previews: PreviewProvider {
    
    static var previews: some View {
        let workout = Workout.new()
        let ioc = IOC()
        WorkoutDetailsView(viewModel: ioc.resolve(WorkoutDetailsViewModel.self, argument: workout))
    }
}

