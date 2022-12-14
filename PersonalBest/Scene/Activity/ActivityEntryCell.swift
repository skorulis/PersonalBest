//Created by Alexander Skorulis on 28/9/2022.

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct ActivityEntryCell {
    let entry: PBRecordEntry
}

// MARK: - Rendering

extension ActivityEntryCell: View {
    
    var body: some View {
        content
    }
    
    private var content: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(entry.dateString)
                    .font(.title)
                
                RecordEntryTags(key: entry.key)
            }
            
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
        if let value = entry.convertedValue(type: type) {
            RecordValueDisplay(value: value, unit: activity.currentUnit(type))
        }
    }
    
    var activity: PBActivity {
        return entry.activity
    }
}

// MARK: - Previews

struct ActivityEntryCell_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = IOC()
        let context = ioc.resolve(CoreDataStore.self).mainContext
        let example = PBActivity(context: context)
        example.name = "Test"
        example.trackingType = .weightlifting
        
        let entry = PBRecordEntry.new(activity: example, values: [.weight: 10, .reps: 5])
        
        return ActivityEntryCell(entry: entry)
    }
}

