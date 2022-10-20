//Created by Alexander Skorulis on 2/10/2022.

import ASSwiftUI
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct WorkoutActivityPickerView {
    
    @StateObject var viewModel: WorkoutActivityPickerViewModel
    @FetchRequest(sortDescriptors: [SortDescriptor(\PBActivity.name)]) var activities: FetchedResults<PBActivity>
    
}

// MARK: - Rendering

extension WorkoutActivityPickerView: View {
    
    var body: some View {
        PageTemplate(nav: nav, content: content)
            .onChange(of: viewModel.searchText) { newValue in
                activities.nsPredicate = newValue.isEmpty ? nil : NSPredicate(format: "name CONTAINS[cd] %@", newValue)
            }
    }
    
    private func nav() -> some View {
        VStack {
            NavBar(left: EmptyView(),
                   mid: BarButtonItem.title("Activities"),
                   right: BarButtonItem.close(viewModel.dismiss)
            )
            TextField("Search", text: $viewModel.searchText)
                .textFieldStyle(.roundedBorder)
        }
    }
    
    private func content() -> some View {
        VStack {
            
            ForEach(activities) { activity in
                Button(action: viewModel.select(activity)) {
                    ActivityCell(activity: activity)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Previews

struct WorkoutActivityPickerView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = IOC()
        let arg = WorkoutActivityPickerViewModel.Argument(onSelect: {_ in })
        return WorkoutActivityPickerView(viewModel: ioc.resolve(WorkoutActivityPickerViewModel.self, argument: arg))
    }
}

