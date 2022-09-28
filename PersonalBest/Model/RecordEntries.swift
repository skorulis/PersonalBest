//Created by Alexander Skorulis on 28/9/2022.

import Foundation

struct RecordEntries: Identifiable {
    let name: String
    let entries: [EntryValue]
    
    var id: String { name }
}

struct EntryValue: Identifiable {
    
    let date: Date
    let value: Decimal
    
    var id: Date { date }
    
}

extension RecordEntries {
    
    static func reps(records: [ActivityEntry]) -> RecordEntries {
        var topValue: Decimal = -1
        var result: [EntryValue] = []
        records.forEach { entry in
            if let value = entry.values[.reps] {
                if value > topValue {
                    topValue = value
                    let entryValue = EntryValue(date: entry.date, value: value)
                    result.append(entryValue)
                }
            }
        }
        
        return RecordEntries(name: "Reps", entries: result)
    }
    
}
