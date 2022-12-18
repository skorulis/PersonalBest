//Created by Alexander Skorulis on 13/11/2022.

import ASKDesignSystem
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct ActivityEditView {
    
    @StateObject var viewModel: ActivityEditViewModel
}

// MARK: - Rendering

extension ActivityEditView: View {
    
    var body: some View {
        PageTemplate(nav: nav, content: content)
    }
    
    private func nav() -> some View {
        NavBar(left: .back(viewModel.back),
               mid: .title("Add Activity"))
    }
    
    private func content() -> some View {
        VStack(alignment: .leading) {
            TextField("Activity name", text: $viewModel.name)
            typePicker
            categoryPicker
            Button(action: viewModel.save) {
                Text("Save")
            }
        }
        .padding(.horizontal, 16)
    }
    
    private var categoryPicker: some View {
        HStack {
            Text("Category")
            Spacer()
            Picker("Category", selection: $viewModel.category) {
                ForEach(viewModel.categories) { cat in
                    Text(cat.name)
                        .tag(cat)
                }
            }
            .pickerStyle(.menu)
        }
    }
    
    private var typePicker: some View {
        HStack {
            Text("Tracking type")
            Spacer()
            Picker("Tracking type", selection: $viewModel.trackingType) {
                ForEach(ActivityTrackingType.allCases) { tracking in
                    Text(tracking.name)
                        .tag(tracking)
                }
            }
            .pickerStyle(.menu)
        }
    }
}

// MARK: - Previews

struct ActivityEditView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = IOC()
        let arg = ActivityEditViewModel.Argument(onSave: {_ in })
        ActivityEditView(viewModel: ioc.resolve(ActivityEditViewModel.self, argument: arg))
    }
}

