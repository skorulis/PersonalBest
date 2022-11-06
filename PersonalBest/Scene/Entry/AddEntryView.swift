//Created by Alexander Skorulis on 27/9/2022.

import ASSwiftUI
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct AddEntryView {
    @StateObject var viewModel: AddEntryViewModel
    
    @Environment(\.navigationType) private var navType
}

// MARK: - Rendering

extension AddEntryView: View {
    
    var body: some View {
        PageTemplate(nav: nav, content: content)
            .onAppear {
                viewModel.navType = navType
            }
    }
    
    private func nav() -> some View {
        DismissingNavBar(mid: BarButtonItem.title("Add record"))
    }
    
    private func content() -> some View {
        VStack {
            ForEach(viewModel.fields) { type in
                field(type: type)
            }
            
            DatePicker(selection: $viewModel.date, displayedComponents: [.date]) {
                Text("Select date")
            }
            
            Button(action: viewModel.selectVariation) {
                Text("Variation: \(viewModel.variantName)")
            }
            .buttonStyle(ShadowButtonStyle())
            
            Button(action: viewModel.save) {
                Text("Save")
            }
            .buttonStyle(ShadowButtonStyle())
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private func field(type: MeasurementType) -> some View {
        HStack {
            switch type {
            case .reps:
                RepsField(value: viewModel.binding(.reps))
            case .weight, .distance:
                DecimalField(type: type, value: viewModel.binding(type))
            case .time:
                TimeField(value: viewModel.binding(.time))
            }
            maybeUnitPicker(type: type)
        }
    }
    
    @ViewBuilder
    private func maybeUnitPicker(type: MeasurementType) -> some View {
        if type.unitOptions.count > 1 {
            Picker(type.name, selection: viewModel.unitTypeBinding(type)) {
                ForEach(type.unitOptions) { unit in
                    Text(unit.symbolString)
                        .tag(unit)
                }
            }
        }
    }
}

// MARK: - Previews

struct AddEntryView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = IOC()
        let coreData = ioc.resolve(CoreDataStore.self)
        let example = PBActivity(context: coreData.mainContext)
        example.name = "Pull up"
        example.trackingType = .reps
        return AddEntryView(viewModel: ioc.resolve(AddEntryViewModel.self, argument: example))
    }
}

