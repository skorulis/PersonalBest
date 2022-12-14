//Created by Alexander Skorulis on 1/10/2022.

import ASKDesignSystem
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
            .environment(\.defaultMinListRowHeight, 20)
    }
    
    private func nav() -> some View {
        NavBar(left: NavBarItem.back(viewModel.back),
               mid: NavBarItem.title("Workout"),
               right: rightButton
        )
    }
    
    private var rightButton: some View {
        Menu {
            Button("Add exercise", action: viewModel.addExercise)
            Button("Finish", action: viewModel.finish)
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
        Color.lightShadow
            .frame(height: 20)
            .deleteDisabled(true)
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
        exerciseCellHeader(exercise)
        ForEach(exercise.sets) { entry in
            WorkoutEntryCell(exercise: exercise,
                             entry: viewModel.binding(exercise, entry),
                             focus: $viewModel.focusPublisher
            )
            .swipeActions(edge: .leading) {
                Button(action: viewModel.duplicate(exercise: exercise, entry: entry)) {
                    Text("Duplicate")
                }
                .tint(.purple)
            }
        }
        .onDelete(perform: viewModel.deleteEntry(exercise: exercise))
        Button(action: {viewModel.addSet(exercise: exercise)}) {
            Text("Add set")
        }
        .deleteDisabled(true)
    }
    
    private func exerciseCellHeader(_ exercise: PBExercise) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(exercise.activity.name)
                    .bold()
                exerciseVolume(exercise)
            }
            Spacer()
            Button(action: {viewModel.detailsPressed(exercise)}) {
                Image(systemName: "info.circle")
            }
        }
    }
    
    private func exerciseVolume(_ exercise: PBExercise) -> some View {
        let vol = exercise.totlaVolume
        return Text("Vol: \(Int(vol.value)) \(vol.symbol)")
    }
    
}

enum WorkoutFocus: Hashable {
    case setEntry(_ exerciseNumber: Int16, setIndex: Int, measurement: MeasurementType)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .setEntry(let number, let setIndex, let measurement):
            hasher.combine(number)
            hasher.combine(setIndex)
            hasher.combine(measurement)
        }
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

