//Created by Alexander Skorulis on 9/10/2022.

import Foundation

/// Service for breaking down arrays of records into more useable chunks
struct BreakdownService {
    
    static let maxReps = 5
    
    func singleBreakdown(type: MeasurementType, records: [PRecordEntry], activity: PBActivity) -> SimpleRecordsBreakdown {
        var topValue: Double = -1
        var result: [RecordKey: [EntryValue]] = [:]
        for entry in records {
            guard entry.autoType == nil else { continue }
            var resultArray = result[entry.key] ?? []
            let values = entry.entryValues
            if let value = values[type], value > topValue {
                topValue = value
                let entryValue = EntryValue(date: entry.date, value: value)
                resultArray.append(entryValue)
                result[entry.key] = resultArray
            }
        }
        return SimpleRecordsBreakdown(activity: activity, values: result)
    }
    
    func repWeightBreakdown(records: [PRecordEntry], activity: PBActivity) -> RepWeightBreakdown {
        var repResults = [RecordKey: [Int: [EntryValue]]]()
        
        for entry in records {
            guard entry.autoType == nil else { continue }
            let values = entry.entryValues
            if let reps = values[.reps], let weight = values[.weight] {
                let repInt = Int(reps)
                let maxxedReps = min(repInt, Self.maxReps)
                var intMap = repResults[entry.key] ?? [:]
                var array = intMap[maxxedReps] ?? []
                let top = array.last?.value ?? -1
                if weight > top {
                    let entryValue = EntryValue(date: entry.date, value: weight)
                    array.append(entryValue)
                    intMap[maxxedReps] = array
                    repResults[entry.key] = intMap
                }
            }
        }
        
        return RepWeightBreakdown(activity: activity, repValues: repResults)
    }
    
}

struct SimpleRecordsBreakdown {
    
    let activity: PBActivity
    var values: [RecordKey: [EntryValue]]
    
}

struct RepWeightBreakdown {
    
    let activity: PBActivity
    var repValues: [RecordKey: [Int: [EntryValue]]]
    
}
