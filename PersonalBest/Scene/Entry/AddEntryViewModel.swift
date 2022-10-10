//Created by Alexander Skorulis on 27/9/2022.

import Foundation
import SwiftUI

// MARK: - Memory footprint

final class AddEntryViewModel: CoordinatedViewModel, ObservableObject {
    
    private let activity: PBActivity
    private let recordAccess: RecordEntryAccess
    
    @Published var date: Date = Date()
    @Published var selectedVariant: PBVariant?
    
    private var values: [MeasurementType: Double] = [:]
    
    init(argument: Argument,
         recordAccess: RecordEntryAccess
    ) {
        self.activity = argument.activity
        self.selectedVariant = argument.initialVariant
        self.recordAccess = recordAccess
    }
    
}

// MARK: - Inner types

extension AddEntryViewModel {
    
    struct Argument {
        let activity: PBActivity
        let initialVariant: PBVariant?
    }
    
}

// MARK: - Computed values

extension AddEntryViewModel {
    
    var fields: [MeasurementType] {
        return activity.measurementTypes
    }
    
    var variantName: String {
        return selectedVariant?.name ?? "None"
    }
    
}

// MARK: - Logic

extension AddEntryViewModel {
    
    func binding(_ type: MeasurementType) -> Binding<Double?> {
        return Binding<Double?> { [unowned self] in
            return self.values[type]
        } set: { [unowned self] newValue in
            self.values[type] = newValue
        }
    }
    
    func save() {
        var measures = [MeasurementType: Double]()
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
        let entry = PBRecordEntry.new(activity: activity, date: date, values: measures)
        entry.variant = selectedVariant
        try! entry.managedObjectContext?.save()
        
        dismiss()
    }
    
    func selectVariation() {
        coordinator.push(.selectVariant(activity, onSelect: { [unowned self] variant in
            self.selectedVariant = variant
        }))
    }
    
}
