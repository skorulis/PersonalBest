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
        HStack {
            Text(entry.dateString)
            Spacer()
            valueList
        }
    }
    
    private var valueList: some View {
        VStack(alignment: .trailing) {
            ForEach(activity.measurementTypes) { type in
                valueItem(type: type)
            }
        }
    }
    
    @ViewBuilder
    private func valueItem(type: MeasurementType) -> some View {
        if let value = entry.values[type] {
            HStack {
                Text(String(describing: value))
                Text(unitString(type: type))
            }
            
        }
        
    }
    
    func unitString(type: MeasurementType) -> String {
        let match = activity.measurements.first(where: {$0.type == type})
        return match?.defaultUnit.unit.symbol ?? ""
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

