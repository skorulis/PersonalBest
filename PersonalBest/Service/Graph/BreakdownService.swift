//Created by Alexander Skorulis on 9/10/2022.

import Foundation

/// Service for breaking down arrays of records into more useable chunks
struct BreakdownService {
    
    static let maxReps = 5
    
    func singleBreakdown(type: MeasurementType, records: [PRecordEntry], activity: PBActivity) -> SimpleRecordsBreakdown {
        var topValue: Decimal = -1
        var result: [String: [EntryValue]] = [:]
        records.forEach { entry in
            let variant = entry.variantName ?? PBVariant.none
            var resultArray = result[variant] ?? []
            let values = entry.entryValues
            if let value = values[type], value > topValue {
                topValue = value
                let entryValue = EntryValue(date: entry.date, value: value)
                resultArray.append(entryValue)
                result[variant] = resultArray
            }
        }
        return SimpleRecordsBreakdown(activity: activity, values: result)
    }
    
    func repWeightBreakdown(records: [PRecordEntry], activity: PBActivity) -> RepWeightBreakdown {
        var repResults = [String: [Int: [EntryValue]]]()
        
        records.forEach { entry in
            let values = entry.entryValues
            if let reps = values[.reps], let weight = values[.weight] {
                let variant = entry.variantName ?? PBVariant.none
                let repInt = (reps as NSDecimalNumber).intValue
                let maxxedReps = min(repInt, Self.maxReps)
                var intMap = repResults[variant] ?? [:]
                var array = intMap[maxxedReps] ?? []
                let top = array.last?.value ?? -1
                if weight > top {
                    let entryValue = EntryValue(date: entry.date, value: weight)
                    array.append(entryValue)
                    intMap[maxxedReps] = array
                    repResults[variant] = intMap
                }
            }
        }
        
        return RepWeightBreakdown(activity: activity, repValues: repResults)
    }
    
}

struct SimpleRecordsBreakdown {
    
    let activity: PBActivity
    var values: [String: [EntryValue]]
    
}

struct RepWeightBreakdown {
    
    let activity: PBActivity
    var repValues: [String: [Int: [EntryValue]]]
    
}
