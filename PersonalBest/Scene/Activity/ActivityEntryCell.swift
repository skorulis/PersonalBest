//Created by Alexander Skorulis on 28/9/2022.

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct ActivityEntryCell {
    let activity: Activity
    let entry: ActivityEntry
}

// MARK: - Rendering

extension ActivityEntryCell: View {
    
    var body: some View {
        content
    }
    
    private var content: some View {
        HStack {
            Text(entry.dateString)
                .font(.title)
            Spacer()
            valueList
        }
        .padding(.horizontal, 16)
    }
    
    private var valueList: some View {
        VStack(alignment: .leading) {
            ForEach(activity.measurementTypes) { type in
                valueItem(type: type)
            }
        }
    }
    
    @ViewBuilder
    private func valueItem(type: MeasurementType) -> some View {
        if let value = entry.values[type] {
            RecordValueDisplay(value: value, unit: getUnit(type: type))
        }
    }
    
    private func getUnit(type: MeasurementType) -> UnitType {
        let match = activity.measurements.first(where: {$0.type == type})
        return match?.defaultUnit ?? type.defaultUnit
    }
}

// MARK: - Previews

struct ActivityEntryCell_Previews: PreviewProvider {
    
    static var previews: some View {
        let activity = Activity(name: "Test", measureTypes: [.weight, .reps])
        let entry = ActivityEntry(date: Date(), values: [.weight: 10, .reps: 5])
        return ActivityEntryCell(activity: activity, entry: entry)
    }
}

