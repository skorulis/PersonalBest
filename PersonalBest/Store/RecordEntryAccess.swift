//Created by Alexander Skorulis on 3/10/2022.

import Foundation

// MARK: - Memory footprint

final class RecordEntryAccess {
    
    private let coreDataStore: CoreDataStore
    
    init(coreDataStore: CoreDataStore) {
        self.coreDataStore = coreDataStore
    }
    
}

// MARK: - Logic

extension RecordEntryAccess {
    
    func add(activity: PBActivity, date: Date, measures: [MeasurementType: Double]) {
        let entry = PBRecordEntry.new(activity: activity, date: date, values: measures)
        try! entry.managedObjectContext?.save()
    }
    
    func topValues(activity: PBActivity) -> [TopValueKey: TopRecord] {
        var best: [TopValueKey: TopRecord] = [:]
        let types = activity.measurementTypes
        for entry in activity.records {
            for type in types {
                guard let value = entry.convertedValue(type: type) else {
                    continue
                }
                let key = entry.topValueKey(type: type)
                
                guard let safebest = best[key] else {
                    best[key] = TopRecord(date: entry.date, value: value, unit: activity.currentUnit(type))
                    continue
                }
                // TODO: Handle backwards types
                if value > safebest.value {
                    best[key] = TopRecord(date: entry.date, value: value, unit: activity.currentUnit(type))
                }
            }
        }
        
        return best
    }
        
}
