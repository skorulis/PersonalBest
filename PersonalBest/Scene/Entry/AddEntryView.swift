//Created by Alexander Skorulis on 27/9/2022.

import ASSwiftUI
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct AddEntryView {
    @StateObject var viewModel: AddEntryViewModel
}

// MARK: - Rendering

extension AddEntryView: View {
    
    var body: some View {
        PageTemplate(nav: nav, content: content)
    }
    
    private func nav() -> some View {
        NavBar(left: EmptyView(),
               mid: BarButtonItem.title("Add record"),
               right:BarButtonItem.close(viewModel.dismiss) )
    }
    
    private func content() -> some View {
        VStack {
            ForEach(viewModel.fields) { type in
                field(type: type)
            }
            
            DatePicker(selection: $viewModel.date, displayedComponents: [.date]) {
                Text("Select date")
            }
            
            Button(action: viewModel.save) {
                Text("Save")
            }
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private func field(type: MeasurementType) -> some View {
        switch type {
        case .reps:
            RepsField(value: viewModel.binding(.reps))
        case .weight, .distance:
            DecimalField(type: type, value: viewModel.binding(type))
        case .time:
            TimeField(value: viewModel.binding(.time))
        }
    }
}

// MARK: - Previews

struct AddEntryView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = IOC()
        let example = PBActivity()
        example.name = "Pull up"
        example.trackingType = .reps
        return AddEntryView(viewModel: ioc.resolve(AddEntryViewModel.self, argument: example))
    }
}

