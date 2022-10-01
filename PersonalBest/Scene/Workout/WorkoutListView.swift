//Created by Alexander Skorulis on 1/10/2022.

import ASSwiftUI
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct WorkoutListView {
    
    @StateObject var viewModel: WorkoutListViewModel
    
}

// MARK: - Rendering

extension WorkoutListView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            nav
            content
        }
    }
    
    private var nav: some View {
        NavBar(left: EmptyView(),
               mid: BarButtonItem.title("Workouts"),
               right: BarButtonItem.iconButton(Image(systemName: "plus"), viewModel.add)
        )
    }
    
    private var content: some View {
        List {
            ForEach(viewModel.workouts) { workout in
                Button(action: viewModel.select(workout: workout)) {
                    WorkoutCell(workout: workout)
                }
            }
            .onDelete(perform: viewModel.delete)
        }
    }
}

// MARK: - Previews

struct WorkoutListView_Previews: PreviewProvider {
    
    static var previews: some View {
        WorkoutListView(viewModel: IOC().resolve())
    }
}
