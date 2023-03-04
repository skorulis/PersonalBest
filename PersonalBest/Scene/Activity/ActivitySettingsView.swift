//Created by Alexander Skorulis on 4/3/2023.

import ASKDesignSystem
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct ActivitySettingsView {
    @StateObject var viewModel: ActivitySettingsViewModel
}

// MARK: - Rendering

extension ActivitySettingsView: View {
    
    var body: some View {
        PageTemplate(nav: nav, content: content)
    }
    
    private func content() -> some View {
        VStack {
            unitEdit
        }
        .padding(.horizontal, 16)
    }
    
    private func nav() -> some View {
        NavBar(mid: NavBarItem.title("Settings"))
    }
    
    @ViewBuilder
    private var unitEdit: some View {
        if !viewModel.editableUnits.isEmpty {
            VStack {
                ForEach(viewModel.editableUnits) { measurement in
                    unitRow(measurement: measurement)
                }
            }
        }
    }
    
    private func unitRow(measurement: MeasurementType) -> some View {
        HStack {
            Text(measurement.name)
            Spacer()
            Picker(measurement.name, selection: viewModel.unitTypeBinding(measurement)) {
                ForEach(measurement.unitOptions) { unit in
                    Text(unit.symbolString)
                        .tag(unit)
                }
            }
        }
        
    }
    
}

// MARK: - Previews

struct ActivitySettingsView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = IOC()
        let context = ioc.resolve(CoreDataStore.self).mainContext
        let example = PBActivity.new(context: context, name: "Pull up", tracking: .weightlifting)
        _ = PBRecordEntry.new(activity: example, date: Date(), values: [.reps: 20])
        _ = PBRecordEntry.new(activity: example, date: Date().advanced(by: 2200000), values: [.reps: 22])
        return ActivitySettingsView(viewModel: ioc.resolve(ActivitySettingsViewModel.self, argument: example))
    }
}

