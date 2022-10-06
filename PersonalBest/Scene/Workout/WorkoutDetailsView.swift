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
            .confirmationDialog("Are you sure you want to delete this workout", isPresented: $viewModel.showingDeletePrompt, titleVisibility: .visible) {
                Button("Delete", role: .destructive, action: viewModel.confirmDelete)
            }
    }
    
    private func nav() -> some View {
        NavBar(left: BarButtonItem.back(viewModel.back),
               mid: BarButtonItem.title("Workout"),
               right: rightButton
        )
    }
    
    private var rightButton: some View {
        Menu {
            Button("Delete", role: .destructive, action: viewModel.delete)
        } label: {
            Image(systemName: "ellipsis.circle")
                .resizable()
                .padding(6)
                .frame(width: 40, height: 40)
                .foregroundColor(.black)
        }
    }
    
    private func content() -> some View {
        Group {
            DatePicker(selection: $viewModel.startDate, displayedComponents: [.date, .hourAndMinute]) {
                Text("Start date")
            }
            
            finishSection
            
            exerciseList
            
            Button(action: viewModel.addExercise) {
                Text("Add exercise")
            }
        }
    }
    
    @ViewBuilder
    private var finishSection: some View {
        if viewModel.hasFinished {
            DatePicker(selection: $viewModel.endDate, displayedComponents: [.date, .hourAndMinute]) {
                Text("End date")
            }
        } else {
            Button(action: viewModel.finish) {
                Text("Finish workout")
            }
        }
    }
    
    private var exerciseList: some View {
        ForEach(viewModel.workout.sortedExercises) { exercise in
            Section {
                exerciseCell(exercise)
            }
        }
        .onDelete(perform: viewModel.delete)
    }
    
    @ViewBuilder
    private func exerciseCell(_ exercise: PBExercise) -> some View {
        Text(exercise.activity.name)
            .bold()
        ForEach(exercise.sets) { entry in
            WorkoutEntryCell(exercise: exercise,
                             entry: viewModel.binding(exercise, entry))
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
        let ioc = IOC()
        let context = ioc.resolve(CoreDataStore.self).mainContext
        let cat = PBCategory(context: context)
        cat.name = "Cat"
        let activity = PBActivity(context: context)
        activity.name = "Test activity"
        activity.category = cat
        activity.trackingType = .reps
        let workout = PBWorkout.new(context: context)
        
        _ = PBExercise.new(workout: workout, activity: activity)
        
        return WorkoutDetailsView(viewModel: ioc.resolve(WorkoutDetailsViewModel.self, argument: workout))
    }
}

