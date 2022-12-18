//Created by Alexander Skorulis on 2/10/2022.


import ASKDesignSystem
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
            DismissingNavBar(mid: NavBarItem.title("Activities"))
            TextField("Search", text: $viewModel.searchText)
                .textFieldStyle(.roundedBorder)
        }
    }
    
    private func content() -> some View {
        VStack {
            ForEach(activities) { activity in
                Button(action: viewModel.select(activity)) {
                    ActivityCell(activity: activity, onInfoPressed: {viewModel.infoPressed(activity)})
                }
            }
            emptyView
        }
        .padding(.horizontal, 16)
    }
    
    private var emptyView: some View {
        VStack {
            Button(action: viewModel.addRecord) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 64, height: 64)
            }
            Text("Create a new activity")
                .typography(.body)
                .frame(maxWidth: .infinity)
        }
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

