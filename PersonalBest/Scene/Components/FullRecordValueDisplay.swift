//Created by Alexander Skorulis on 20/12/2022.

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct FullRecordValueDisplay {
    let record: PBRecordEntry
}

// MARK: - Rendering

extension FullRecordValueDisplay: View {
    
    var body: some View {
        switch record.activity.trackingType {
        case .weightlifting:
            weightsDisplay
        case .reps:
            singleDisplay(type: .reps)
        case .time:
            singleDisplay(type: .time)
        case .cardio:
            Text("CARDIO DISPLAY")
        }
    }
    
    private var weightsDisplay: some View {
        let reps = record.value(type: .reps)
        let weightUnit = record.activity.currentUnit(.weight)
        let weight = record.convertedValue(type: .weight, toUnit: weightUnit)!
        
        return HStack(spacing: 4) {
            RecordValueDisplay(
                value: weight,
                unit: record.activity.currentUnit(.weight)
            )
            
            if let reps {
                Text("@")
                    .typography(.body)
                RecordValueDisplay(
                    value: reps,
                    unit: record.activity.currentUnit(.reps)
                )
            }
        }
    }
    
    private func singleDisplay(type: MeasurementType) -> some View {
        let value = record.value(type: type)!
        return RecordValueDisplay(
            value: value,
            unit: record.activity.currentUnit(type)
        )
    }
    
}

// MARK: - Previews

struct FullRecordValueDisplay_Previews: PreviewProvider {
    
    static let ioc = IOC()
    
    static var previews: some View {
        let context = ioc.resolve(CoreDataStore.self).mainContext
        
        let activity = PreviewData.longActivity(context)
        
        let entry = PBRecordEntry.new(activity: activity, values: [.reps: 10, .weight: 2000])
        
        VStack {
            FullRecordValueDisplay(record: entry)
            
        }
    }
}

