//Created by Alexander Skorulis on 27/9/2022.

import Foundation
import SwiftUI

// MARK: - Memory footprint

final class AddEntryViewModel: CoordinatedViewModel, ObservableObject {
    
    private let activity: Activity
    private let records: RecordsStore
    
    @Published var date: Date = Date()
    
    private var values: [MeasurementType: Decimal] = [:]
    
    init(activity: Activity,
         records: RecordsStore
    ) {
        self.activity = activity
        self.records = records
    }
    
}

// MARK: - Computed values

extension AddEntryViewModel {
    
    var fields: [MeasurementType] {
        return activity.measurementTypes
    }
    
}

// MARK: - Logic

extension AddEntryViewModel {
    
    func binding(_ type: MeasurementType) -> Binding<Decimal?> {
        return Binding<Decimal?> { [unowned self] in
            return self.values[type]
        } set: { newValue in
            self.values[type] = newValue
        }
    }
    
    func save() {
        var measures = [MeasurementType: Decimal]()
        for field in fields {
            guard let value = binding(field).wrappedValue else {
                // TODO: Show error
                return
            }
            guard value > 0 else {
                return
            }
            measures[field] = value
        }
        let entry = ActivityEntry(date: date, values: measures)
        records.add(entry: entry, activity: activity)
        
        dismiss()
    }
    
}
