//Created by Alexander Skorulis on 1/10/2022.

import ASSwiftUI
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct WorkoutListView {
    
    @StateObject var viewModel: WorkoutListViewModel
    
    @FetchRequest(sortDescriptors: [.init(key: "startDate", ascending: true)]) var workouts: FetchedResults<PBWorkout>
    
}

// MARK: - Rendering

extension WorkoutListView: View {
    
    var body: some View {
        ListTemplate(nav: nav, content: content)
    }
    
    private func nav() -> some View {
        NavBar(left: EmptyView(),
               mid: BarButtonItem.title("Workouts"),
               right: BarButtonItem.iconButton(Image(systemName: "plus"), viewModel.add)
        )
    }
    
    private func content() -> some View {
        ForEach(workouts) { workout in
            Button(action: viewModel.select(workout: workout)) {
                WorkoutCell(workout: workout)
            }
            .id(workout.versionID)
        }
        .onDelete(perform: delete)
    }
}

// MARK: - Logic

extension WorkoutListView {
    
    func delete(indexes: IndexSet) {
        indexes.forEach { index in
            viewModel.delete(workout: workouts[index])
        }
    }
    
}

// MARK: - Previews

struct WorkoutListView_Previews: PreviewProvider {
    
    static var previews: some View {
        WorkoutListView(viewModel: IOC().resolve())
    }
}

